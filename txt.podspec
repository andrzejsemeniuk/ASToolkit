0   % pod spec create https://github.com/andrzejsemeniuk/ASToolkit

1   % git flow release start X.Y.Z
2   % vi ASToolkit.podspec // and change the version number to X.Y.Z
3   % git commit // commit changes to podspec file, AND PUSH TO ORIGIN !!!
4   % pod spec lint --allow-warnings ASToolkit.podspec
5   % pod trunk push --allow-warnings ASToolkit.podspec
6   % git flow release finish
7   // on github, create a release tagged 'release/X.Y.Z'
