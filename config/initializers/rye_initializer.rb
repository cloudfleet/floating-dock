Rye::Cmd.add_command :build_and_push, 'marina/scripts/build_and_push_docker_image.sh'
Rye::Cmd.add_command :version, 'marina/scripts/version.sh'
Rye::Cmd.add_command :rm, ['-rf', 'marina']
