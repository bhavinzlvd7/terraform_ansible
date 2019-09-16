import sys
def parse_tfstate(filename):
    fo = open(filename, "r")
    str = fo.read()
    fo.close()

    replace_dict = { ': false': ': False',
                     ': true': ': True',
                     ': null': ': None'
                   }

    for key, val in replace_dict.items():
        str = str.replace(key, val)

    my_data = eval(str)
    ret_dict = {}

    for resource in my_data['resources']:

        if resource['type'] == "azurerm_mysql_server":
            ret_dict['resource_group'] = resource['instances'][0]['attributes']['resource_group_name']
            ret_dict['location'] = resource['instances'][0]['attributes']['location']
            ret_dict['mysql_server'] = resource['instances'][0]['attributes']['name']
            ret_dict['mysql_username'] = resource['instances'][0]['attributes']['administrator_login']
            ret_dict['mysql_password'] = resource['instances'][0]['attributes']['administrator_login_password']

        elif resource['type'] == "azurerm_mysql_database":
            ret_dict['db_name'] = resource['instances'][0]['attributes']['name']

        elif resource['type'] == "azurerm_public_ip":
            ret_dict['vm_ip'] = resource['instances'][0]['attributes']['ip_address']

        elif resource['type'] == "azurerm_virtual_machine":
            ret_dict['vm_username'] = resource['instances'][0]['attributes']['os_profile'][0]['admin_username']

    return ret_dict

def create_files(in_dict, out_dir):
    fo = open("%s/group_vars/all" % out_dir, "w")
    str = '''
    resource_group:
        name: {}
        location: {}

    admin_username: {}

    mysql:
        server_name: {}
        db_name: {}
        username: {}
        password: {}
        port: 3306
    '''.format(in_dict['resource_group'],
               in_dict['location'],
               in_dict['vm_username'],
               in_dict['mysql_server'],
               in_dict['db_name'],
               in_dict['mysql_username'],
               in_dict['mysql_password'])
    fo.write(str)
    fo.close()

    fo = open("%s/inv" % out_dir, "w")
    str = '''
    [myVM]
    {}

    [myVM:vars]
    ansible_user={}
    '''.format(in_dict['vm_ip'],
               in_dict['vm_username'])
    fo.write(str)
    fo.close()


if __name__ == "__main__":
    if len(sys.argv) > 2:
        create_files(parse_tfstate(sys.argv[1]), sys.argv[2])
    else:
        print("Error: Enter tfstate file")
