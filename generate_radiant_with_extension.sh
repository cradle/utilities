#!/bin/bash -x

if [ -z "$1" ]; then
  echo " usage: $0 extension-name"
  exit
fi

hyphenated=${1//_/-}
underscored=${1//-/_}

radiant --quiet "$underscored"
cd "$underscored"/vendor/extensions
git clone git@github.com:tricycle/radiant-"$hyphenated"-extension.git $underscored
cd ../..
mysqladmin drop -u root "$underscored"_development
mysqladmin create -u root "$underscored"_development
mysqladmin drop -u root "$underscored"_test
mysqladmin create -u root "$underscored"_test
rake db:bootstrap
rake db:test:clone_structure
rake radiant:extensions:"$underscored":migrate
cd vendor/extensions/"$underscored"
rake spec
