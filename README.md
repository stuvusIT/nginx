# nginx

Sets up a nginx serving HTTPS with the configured domain names.


## Requirements

An apt-based package manager and systemd


## Role Variables

| Role variable                  | Default | Description                                                                                   |
| :----------------------------- | :------ | :-------------------------------------------------------------------------------------------- |
| `nginx_install_full_package`   | `false` | Whether to install the `nginx-full` package instead of the normal `nginx` package             |
| `nginx_default_privkey_path`   |         | Default value in [served domain objects](#served-domain-objects) without `privkey_path` key   |
| `nginx_default_fullchain_path` |         | Default value in [served domain objects](#served-domain-objects) without `fullchain_path` key |


### Nginx service-related
See the [nginx doc](https://nginx.org/en/docs/http/ngx_http_core_module.html) for a description of the variables.

| Role variable                     | Default                                                                                           |
| :-------------------------------- | :------------------------------------------------------------------------------------------------ |
| `nginx_user`                      | `www-data`                                                                                        |
| `nginx_worker_processes`          | `auto`                                                                                            |
| `nginx_pid`                       | `/run/nginx.pid`                                                                                  |
| `nginx_worker_connections`        | `768`                                                                                             |
| `nginx_sendfile`                  | `on`                                                                                              |
| `nginx_tcp_nopush`                | `on`                                                                                              |
| `nginx_tcp_nodelay`               | `on`                                                                                              |
| `nginx_keepalive_timeout`         | `65`                                                                                              |
| `nginx_types_hash_max_size`       | `2048`                                                                                            |
| `nginx_server_tokens`             | `off`                                                                                             |
| `nginx_default_type`              | `application/octet-stream`                                                                        |
| `nginx_ssl_protocols`             | `TLSv1 TLSv1.1 TLSv1.2`                                                                           |
| `nginx_ssl_ciphers`               | `EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH`                                                 |
| `nginx_ssl_prefer_server_ciphers` | `on`                                                                                              |
| `nginx_log_format`                | See defaults                                                                                      |
| `nginx_access_log`                | `/var/log/nginx/access.log`                                                                       |
| `nginx_error_log`                 | `/var/log/nginx/error.log`                                                                        |
| `nginx_gzip`                      | `on`                                                                                              |
| `nginx_gzip_disable`              | `msie6`                                                                                           |
| `nginx_gzip_types`                | See defaults.                                                                                     |
| `nginx_pam_rules`                 | List of pam rules to configure a pam service. For a defenition of objects in that list see below. |
| `nginx_pam_service_name`          | Name of the pam service that should ne created. Mandatory when setting `nginx_pam_rules`          |
| `nginx_allow_shadow`              | Allow nginx (www-data) access to shadow group, needed for PAM authentication                      |


### Domain-related

| Role variable      | Mandatory          | Description                                                                                  |
| :----------------- | :----------------- | :------------------------------------------------------------------------------------------- |
| `domain_suffixes`  | :heavy_check_mark: | Domain suffixes to support multiple domain endings like ticket.test.de. and ticket.test.com. |
| `domain_preffixes` | :heavy_check_mark: | Domain preffixes like www                                                                    |
| `served_domains`   | :heavy_check_mark: | List of [served domain objects](#served-domain-objects)                                      |


#### Served domain objects

A served domain object is a dictionary which can contain the following keys.

| Key                       |        Mandatory         | Description                                                                                    |
| :------------------------ | :----------------------: | :--------------------------------------------------------------------------------------------- |
| `domains`                 | :heavy_multiplication_x: | A list of server names. Semantically defaults to `_`. See below regarding the syntax.          |
| `fullchain_path`          | :heavy_multiplication_x: | HTTPS certificate path. Defaults to the content of `nginx_default_fullchain_path`.             |
| `privkey_path`            | :heavy_multiplication_x: | Private key path for the certificate. Defaults to the content of `nginx_default_privkey_path`. |
| `default_server`          |    :heavy_check_mark:    | Should this server be the default server to answer request                                     |
| `allowed_ip_ranges`       | :heavy_multiplication_x: | IP ranges that are allowed to access this server. By default all IPs are allowed.              |
| `https`                   |    :heavy_check_mark:    | Should this domain use HTTPS                                                                   |
| `index`                   |    :heavy_check_mark:    | For which index files should nginx look                                                        |
| `locations.condition`     |    :heavy_check_mark:    | The condition under which this locations block is called                                       |
| `locations.content`       |    :heavy_check_mark:    | Content of the locations block                                                                 |
| `locations.ignore_access` | :heavy_multiplication_x: | Ignore the default access behaviour                                                            |
| `fastcgi_buffers`         | :heavy_multiplication_x: |                                                                                                |
| `client_max_body_size`    | :heavy_multiplication_x: | File Upload size                                                                               |
| `headers`                 | :heavy_multiplication_x: | List of headers that should be used for this server block                                      |
| `nginx_skip_server`       | :heavy_multiplication_x: | Don't generate a server entry for this server                                                  |

For the `domains` key, fully qualified server names must end in a dot (i.e. `test.de.`).
Otherwise, `domain_suffixes` and `domain_prefixes` are applied.


### Upstream Vars

`nginx_upstreams` is a list of dictionaries containing the following keys.

| Name      |        Mandatory        | Description                                     |
| :-------- | :---------------------: | :---------------------------------------------- |
| `name`    |   :heavy_check_mark:    | Upstream name used in domain_vars               |
| `path`    | If `content` is not set | URL or socket to PHP listener                   |
| `content` |  If `path` is not set   | Content to be placed in the upstream directive. |

At least one of `path` and `content` must be set.
If both are set, then `path` is used and `content` is ignored.


### Maps

`nginx_maps` is a list of dictionaries containing the following keys.

| Name        |     Mandatory      | Description                       |
| :---------- | :----------------: | :-------------------------------- |
| `condition` | :heavy_check_mark: | Map condition used in domain_vars |
| `content`   | :heavy_check_mark: | map content                       |


### Global Vars

`nginx_global` is a list of dictionaries containing the following entry.

| Name      |     Mandatory      | Description                            |
| :-------- | :----------------: | :------------------------------------- |
| `content` | :heavy_check_mark: | content of the line that should be set |


### Pam Rules

`nginx_pam_rules` is a list of dictionaries containing the following keys.

| Name          |     Mandatory      | Description                                                           |
| :------------ | :----------------: | :-------------------------------------------------------------------- |
| `type`        | :heavy_check_mark: | The type of the rule either `account`, `auth`,`password` or `session` |
| `control`     | :heavy_check_mark: | The control behavior of the rule                                      |
| `module_path` | :heavy_check_mark: | the module name where the request should be handed to                 |

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

A running nginx with the specified configuration.


## License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).


## Author Information

 * [Fritz Otlinghaus (Scriptkiddi)](https://github.com/Scriptkiddi) _fritz.otlinghaus@stuvus.uni-stuttgart.de_
