chmod a-r /tmp

for i in 1 2 3; do
  ruby -rsecurerandom -e "puts 'FLAG-module_$i-'+SecureRandom.hex" > /modules/module_$i/flag
  chown root:module_$i /modules/module_$i/flag
  chmod 440 /modules/module_$i/flag
done

xinetd -d -dontfork
