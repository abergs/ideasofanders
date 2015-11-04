set filename=%date%-%1.md
copy .\_posts\_postTemplate.md .\_posts\%filename%
start .\_posts\%filename%