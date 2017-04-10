# Nginx Role 

Sets up a nginx serving https with the configured domain names.


## Requirements

An apt-based package manager

## Role Variables

```yml

```


## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:


### Playbook

```yml
```


### Vars

```yml
domain_suffixe:
  - stuvus.uni-stuttgart.de.
  - stuvus.de.

domain_prefixe;
  - www
served_domains:
  - domains: 
    - ticket
    - zammad
    privkey_path: <path at target server>  # privkey.pem will placed there>
    fullchain_path: <path at target server>  # fullchain.pem will placed there>
    default_server: [true|false*]
    allowed_ip_ranges:
      - 172.27.10.0/24
    https: true
    index:
      - index.php
      - index.html
    locations:
      - condition: /
        content:
        | 
          try_files $1 $uri $uri/ /index.php$is_args$args;
      - condition: ~ ^/index\.php(.*)$
        content:
        | 
         fastcgi_index index.php;
         include /etc/nginx/fastcgi_params;
         try_files $uri =404;
         fastcgi_split_path_info ^(.+\.php)(/.+)$;
         fastcgi_pass unix:/run/php/php7.0-fpm.sock;m
         fastcgi_param SCRIPT_FILENAME /usr/share/icingaweb2/public/index.php;
         fastcgi_param ICINGAWEB_CONFIGDIR /etc/icingaweb2;
         fastcgi_param REMOTE_USER $remote_user;

```


### Result

A short summary what the playbook actually does.


## License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).


## Author Information

 * [Fritz Otlinghaus (Scriptkiddi)](https://github.com/Scriptkiddi) _fritz.otlinghaus@stuvus.uni-stuttgart.de_
