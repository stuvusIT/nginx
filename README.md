# Nginx Role 

Sets up a nginx serving https with the configured domain names.


## Requirements

An apt-based package manager

## Role Variables

### Nginx Vars
See the [nginx doc](https://nginx.org/en/docs/http/ngx_http_core_module.html) for a description of the variables.

| Name                              |         Required         | Default                                                                                           |
|:----------------------------------|:------------------------:|:--------------------------------------------------------------------------------------------------|
| `nginx_user`                      | :heavy_multiplication_x: | `www-data`                                                                                        |
| `nginx_worker_processes`          | :heavy_multiplication_x: | `auto`                                                                                            |
| `nginx_pid`                       | :heavy_multiplication_x: | `/run/nginx.pid`                                                                                  |
| `nginx_worker_connections`        | :heavy_multiplication_x: | `768`                                                                                             |
| `nginx_sendfile`                  | :heavy_multiplication_x: | `on`                                                                                              |
| `nginx_tcp_nopush`                | :heavy_multiplication_x: | `on`                                                                                              |
| `nginx_tcp_nodelay`               | :heavy_multiplication_x: | `on`                                                                                              |
| `nginx_keepalive_timeout`         | :heavy_multiplication_x: | `65`                                                                                              |
| `nginx_types_hash_max_size`       | :heavy_multiplication_x: | `2048`                                                                                            |
| `nginx_server_tokens`             | :heavy_multiplication_x: | `off`                                                                                             |
| `nginx_default_type`              | :heavy_multiplication_x: | `application/octet-stream`                                                                        |
| `nginx_ssl_protocols`             | :heavy_multiplication_x: | `TLSv1 TLSv1.1 TLSv1.2`                                                                           |
| `nginx_ssl_ciphers`               | :heavy_multiplication_x: | `EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH`                                                 |
| `nginx_ssl_prefer_server_ciphers` | :heavy_multiplication_x: | `on`                                                                                              |
| `nginx_log_format`                | :heavy_multiplication_x: | See defaults                                                                                      |
| `nginx_access_log`                | :heavy_multiplication_x: | `/var/log/nginx/access.log`                                                                       |
| `nginx_error_log`                 | :heavy_multiplication_x: | `/var/log/nginx/error.log`                                                                        |
| `nginx_gzip`                      | :heavy_multiplication_x: | `on`                                                                                              |
| `nginx_gzip_disable`              | :heavy_multiplication_x: | `msie6`                                                                                           |
| `nginx_gzip_types`                | :heavy_multiplication_x: | See defaults.                                                                                     |
| `nginx_pam_rules`                 | :heavy_multiplication_x: | List of pam rules to configure a pam service. For a defenition of objects in that list see below. |
| `nginx_pam_service_name`          | :heavy_multiplication_x: | Name of the pam service that should ne created. Mandatory when setting `nginx_pam_rules`          |

### Domain Vars
| Name                                     | Required                 | Default | Description                                                                                                                                     |
|:-----------------------------------------|:------------------------:|:--------|:------------------------------------------------------------------------------------------------------------------------------------------------|
| `domain_suffixes`                        | :heavy_check_mark:       |         | Domain suffixes to support multiple domain endings like ticket.test.de. and ticket.test.com.                                                    |
| `domain_preffixe`                        | :heavy_check_mark:       |         | Domain preffixe like www                                                                                                                        |
| `served_domains`                         | :heavy_check_mark:       |         | A list of the served domains                                                                                                                    |
| `served_domains.domains`                 | :heavy_check_mark:       |         | A list of server names if you do not enter a fully qualifed name like test.de. the server will append all combinations with the given preffixes |
| `served_domains.privkey_path`            | :heavy_check_mark:       |         | The path to a privet key for the https cert                                                                                                     |
| `served_domains.fullchain_path`          | :heavy_check_mark:       |         | The path to a cert for https                                                                                                                    |
| `served_domains.default_server`          | :heavy_check_mark:       |         | Should this server be the default server to awnser request                                                                                      |
| `served_domains.allowed_ip_ranges`       | :heavy_multiplication_x: | all     | IP ranges that are allowed to access this server by default are all ips allowed                                                                 |
| `served_domains.https`                   | :heavy_check_mark:       |         | Should this domain use https                                                                                                                    |
| `served_domains.index`                   | :heavy_check_mark:       |         | For which index files should nginx look                                                                                                         |
| `served_domains.locations.condition`     | :heavy_check_mark:       |         | The condition under which this locations block is called                                                                                        |
| `served_domains.locations.content`       | :heavy_check_mark:       |         | Content of the locations block                                                                                                                  |
| `served_domains.locations.ignore_access` | :heavy_multiplication_x: |         | Ignore the default access behaviour                                                                                                             |
| `served_domains.fastcgi_buffers`         | :heavy_multiplication_x: |         |                                                                                                                                                 |
| `served_domains.client_max_body_size`    | :heavy_multiplication_x: |         | File Upload size                                                                                                                                |
| `served_domains.headers`                 | :heavy_multiplication_x: |         | List of headers that should be used for this server block                                                                                       |
| `served_domains.nginx_skip_server`       | :heavy_multiplication_x: |         | Don't generate a server entry for this server                                                                                                   |

## Global Values
upstream, maps, and global vars are to be defined by using either
`nginx_upstreams`, `nginx_maps`, `nginx_global`.

### Upstream Vars
`nginx_upstreams` is a list of dicts containing the following two entries.
| Name   |      Required      | Default | Description                       |
|:-------|:------------------:|:--------|:----------------------------------|
| `name` | :heavy_check_mark: |         | Upstream name used in domain_vars |
| `path` | :heavy_check_mark: |         | url or socket to php listener     |

### Maps
`nginx_maps` is a list of dicts containing the following two entries.
| Name        |      Required      | Default | Description                       |
|:------------|:------------------:|:--------|:----------------------------------|
| `condition` | :heavy_check_mark: |         | Map condition used in domain_vars |
| `content`   | :heavy_check_mark: |         | map content                       |

### Global Vars
`nginx_global` is a list of dicts containing the following entry.
| Name      |      Required      | Default | Description                            |
|:----------|:------------------:|:--------|:---------------------------------------|
| `content` | :heavy_check_mark: |         | content of the line that should be set |

### Pam Rules
`nginx_pam_rules` is a list of dicts containing the following entry.
| Name          |      Required      | Default | Description                                                           |
|:--------------|:------------------:|:--------|:----------------------------------------------------------------------|
| `type`        | :heavy_check_mark: |         | The type of the rule either `account`, `auth`,`password` or `session` |
| `control`     | :heavy_check_mark: |         | The control behavior of the rule                                      |
| `module_path` | :heavy_check_mark: |         | the module name where the request should be handed to                 |
For more information on pam rules see the [Linux Administration Guide](http://www.linux-pam.org/Linux-PAM-html/sag-configuration-file.html)

## Example Playbook

Configure a served_domain like 

### Vars

```yml
domain_suffixes:
  - stuvus.uni-stuttgart.de.
  - stuvus.de.
nginx_global:
  - content:
    |
    <content goes here>;
nginx_upstreams:
  - name: "server"
    path: 127.0.0.1:8080
nginx_maps:
  - condition: <condition>
    content: |
      <content goes here>

domain_prefixes:
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
    index_files:
      - index.php
      - index.html
    enable_http2: true
    configurations:
      - content:
        |
        <content goes here>;
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

A running nginx with specified config


## License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).


## Author Information

 * [Fritz Otlinghaus (Scriptkiddi)](https://github.com/Scriptkiddi) _fritz.otlinghaus@stuvus.uni-stuttgart.de_
