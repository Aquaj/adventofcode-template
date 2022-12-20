for file in $(ls day*.rb)
do
  echo $file
  bundle exec ruby $file --validate || exit 1
done
exit 0
