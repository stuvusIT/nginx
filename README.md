# Nginx Role 

Sets up a nginx serving https with the configured domain names.


## Requirements

An apt-based package manager

## Role Variables

### Nginx Vars
See the [nginx doc](https://nginx.org/en/docs/http/ngx_http_core_module.html) for a description of the variables.

| Name                      | Required                 | Default        | 
|---------------------------|:------------------------:|---------------|
| `nginx.user`          | :heavy_multiplication_x:       | `www-data`          |
| `nginx.worker_processes`          | :heavy_multiplication_x:       | `auto`  |
| `nginx.pid`          | :heavy_multiplication_x:       | `/run/nginx.pid`|
| `nginx.worker_connections`          | :heavy_multiplication_x:       | `768` |
| `nginx.sendfile`          | :heavy_multiplication_x:       | `on` |
| `nginx.tcp_nopush`          | :heavy_multiplication_x:       | `on`          |
| `nginx.tcp_nodelay`          | :heavy_multiplication_x:       | `on`         |
| `nginx.keepalive_timeout`          | :heavy_multiplication_x:       | `65`|
| `nginx.types_hash_max_size`          | :heavy_multiplication_x:       | `2048`|
| `nginx.server_tokens`          | :heavy_multiplication_x:       | `off`|
| `nginx.default_type`          | :heavy_multiplication_x:       | `application/octet-stream`|
| `nginx.ssl_protocols`          | :heavy_multiplication_x:       | `TLSv1 TLSv1.1 TLSv1.2`|
| `nginx.ssl_ciphers`          | :heavy_multiplication_x:       | `EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH`|
| `nginx.ssl_prefer_server_ciphers`          | :heavy_multiplication_x:       | `on`|
| `nginx.log_format`          | :heavy_multiplication_x:       | See defaults|
| `nginx.access_log`          | :heavy_multiplication_x:       | `/var/log/nginx/access.log`|
| `nginx.error_log`          | :heavy_multiplication_x:       | `/var/log/nginx/error.log`|
| `nginx.gzip`          | :heavy_multiplication_x:       | `on`|
| `nginx.gzip_disable`          | :heavy_multiplication_x:       | `msie6`|
| `nginx.gzip_types`          | :heavy_multiplication_x:       | See defaults.|

### Domain Vars
| Name                      | Required                 | Default         | Description                                                                     |
|---------------------------|:------------------------:|-----------------|---------------------------------------------------------------------------------|
| `domain_suffixe`          | :heavy_check_mark:       |          | Domain suffixe to support multiple domain endings like ticket.test.de. and ticket.test.com.|
| `domain_preffixe`          | :heavy_check_mark:       |          | Domain preffixe like www |
| `served_domains`          | :heavy_check_mark:       |          | A list of the served domains|
| `served_domains.domains`          | :heavy_check_mark:       |          | A list of server names if you do not enter a fully qualifed name like test.de. the server will append all combinations with the given preffixes|
| `served_domains.privkey_path`          | :heavy_check_mark:       |          | The path to a privet key for the https cert|
| `served_domains.fullchain_path`          | :heavy_check_mark:       |          | The path to a cert for https|
| `served_domains.default_server`          | :heavy_check_mark:       |          | Should this server be the default server to awnser request|
| `served_domains.allowed_ip_ranges`          | :heavy_multiplication_x:       |     all     | IP ranges that are allowed to access this server by default are all ips allowed |
| `served_domains.https`          | :heavy_check_mark:       |          | Should this domain use https|
| `served_domains.index`          | :heavy_check_mark:       |          | For which index files should nginx look|
| `served_domains.locations.condition`          | :heavy_check_mark:       |          | The condition under which this locations block is called|
| `served_domains.locations.content`          | :heavy_check_mark:       |          | Content of the locations block|



## Example Playbook

Configure a served_domain like 


### Playbook

```yml
```


### Vars

```yml
domain_suffixe:
  - stuvus.uni-stuttgart.de.
  - stuvus.de.

domain_preffixe:
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

A running nginx with specificed config


## License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).


## Author Information

 * [Fritz Otlinghaus (Scriptkiddi)](https://github.com/Scriptkiddi) _fritz.otlinghaus@stuvus.uni-stuttgart.de_
