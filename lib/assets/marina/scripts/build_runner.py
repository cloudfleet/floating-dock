#!/usr/bin/python

import time
import json
import urllib2
import urllib
import sys
import subprocess
import os

CONFIG_FILE = "/etc/floating-dock/builder/config.json"

def load_config():
    try:
        with open(CONFIG_FILE, "r") as config_file:
            return json.load(config_file)
    except:
        print "No config found."
        return None

def register_builder(new_builder_key, builder_name, floating_dock_address):
    values = {
        "key": new_builder_key,
        "name": builder_name
    }
    url = "%s/api/v1/builders" % floating_dock_address
    data = urllib.urlencode(values)
    req = urllib2.Request(url, data)
    response = urllib2.urlopen(req)
    config = json.load(response)

    with open(CONFIG_FILE, "w+") as config_file:
        json.dump(config, config_file)

    return config

def request_build(config, floating_dock_address):
    url = "%s/api/v1/builders/%s/request_build" % (floating_dock_address, config["id"])
    req = urllib2.Request(url, urllib.urlencode({"post":"true"}), {"X-FLOATING-DOCK-BUILDER-KEY": config["auth_key"]})
    response = urllib2.urlopen(req)
    return json.load(response)

def build_and_push(build_config, config, floating_dock_address):
    build_script = os.path.dirname(os.path.abspath(__file__)) + "/build_and_push_docker_image.sh"

    p = subprocess.Popen([
        build_script,
        build_config["build"]["repository_url"],
        build_config["build"]["repository_branch"],
        build_config["build"]["docker_file_path"],
        build_config["build"]["image_name"],
        build_config["registry"]["host"],
        build_config["registry"]["user"],
        build_config["registry"]["password"],
        build_config["registry"]["email"]
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    stdout, stderr = p.communicate()

    success = p.returncode == 0

    if success:
        status = "pushed"
    else:
        status = "failed"

    values = {
        "build_id": build_config["build"]["id"],
        "status": status,
        "stdout": stdout,
        "stderr": stderr
    }
    url = "%s/api/v1/builders/%s/update_build" % (floating_dock_address, config["id"])
    data = urllib.urlencode(values)
    req = urllib2.Request(url, data, {"X-FLOATING-DOCK-BUILDER-KEY": config["auth_key"]})
    response = urllib2.urlopen(req)


def main():

    floating_dock_address = sys.argv[1]
    new_builder_key = sys.argv[2]
    builder_name = sys.argv[3]
    config = load_config()

    if not config:
        print("Registering builder ...")
        config = register_builder(new_builder_key, builder_name, floating_dock_address)
        print("Registered.")

    while True:
        try:
            print("Request build ...")
            new_build = request_build(config, floating_dock_address)

            if new_build:
                print("Building")
                build_and_push(new_build, config, floating_dock_address)
            else:
                time.sleep(30)
        except Exception as detail:
           print("Failed to build: %s" % detail)

if  __name__ =='__main__':
    main()
