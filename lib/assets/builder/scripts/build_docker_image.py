#!/usr/bin/python
import tempfile
import subprocess
import re
import sys
import json
import urllib2


#pattern = re.compile('^from (.*)$', re.IGNORECASE | re.MULTILINE)
pattern = re.compile('^from (.*)$', re.IGNORECASE | re.MULTILINE)


def do_build(repository_url, image_name, image_tag, registry, library_arch, repository_branch='master', dockerfile_path='/', image_additional_tags=''):

  print("Creating working directory ...")
  working_directory = tempfile.mkdtemp()
  print(" - working directory is %s" % working_directory)

  print("Building image: %s" % image_name)
  print("------------------------------")
  print(" - fetching %s (%s) to %s" % (repository_url, repository_branch, working_directory))
  response_code = subprocess.call(['git', 'clone', repository_url, working_directory])
  if response_code != 0:
    sys.exit(response_code)
  p = subprocess.Popen(['git', 'checkout', repository_branch], cwd=working_directory)
  p.communicate()
  if p.returncode != 0:
    sys.exit(p.returncode)

  print(" - building Docker image as %s/%s:%s" % (registry,image_name,image_tag) )
  response_code =  subprocess.call(['docker', 'build', '-t', '%s/%s:%s' % (registry,image_name,image_tag), '%s/%s' % (working_directory, dockerfile_path)])
  if response_code != 0:
    sys.exit(response_code)
  print(" - image built")
  for tag in image_additional_tags.split(','):
    tag = tag.strip()
    if tag:
      print(" - tagging as %s/%s:%s" % (registry,image_name,tag))
      subprocess.call(['docker', 'tag', '%s/%s:%s' % (registry,image_name,image_tag), '%s/%s:%s' % (registry,image_name,tag)])
      if response_code != 0:
        sys.exit(response_code)

  subprocess.call(['rm', '-rf', working_directory])


def main():

    repository_url = sys.argv[1]
    repository_branch = sys.argv[2]
    dockerfile_path = sys.argv[3]
    image_repository = sys.argv[4]
    image_tag = sys.argv[5]
    image_additional_tags = sys.argv[6]
    registry = sys.argv[7]
    library_arch = sys.argv[8]

    do_build(repository_url, image_repository, image_tag, "%s.%s" % (library_arch, registry), library_arch, repository_branch=repository_branch, dockerfile_path=dockerfile_path, image_additional_tags=image_additional_tags)

if  __name__ =='__main__':
    main()
