[Permissions](syncronize-file-permissions.md) |
[Tags](docker-tags.md) |
[Architectures](supported-architectures.md) |
[Versions](php-versions.md) |
[Flavours](flavours.md) |
[Extensions](php-modules.md) |
[Tools](available-tools.md) |
Env Vars |
[Volumes](docker-volumes.md) |
[Base Images](base-images.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Documentation</h2>



### Environment Variables

Have a look at the following table to see all supported environment variables for each Docker image flavour.
<table>
 <thead>
  <tr>
   <th>Image</th>
   <th>Env Variable</th>
   <th>Type</th>
   <th>Default</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td rowspan="3"><strong>base</strong><br/><br/><strong>mods</strong><br/><br/><strong>prod</strong><br/><br/><strong>work</strong></td>
   <td><code>DEBUG_ENTRYPOINT</code></td>
   <td>int</td>
   <td><code>0</code></td>
   <td>Set debug level for startup.<br/><sub><code>0</code> Only warnings and errors are shown.<br/><code>1</code> All log messages are shown<br/><code>2</code> All log messages and executed commands are shown.</sub></td>
  </tr>
  <tr>
   <td><code>NEW_UID</code></td>
   <td>int</td>
   <td><code>1000</code></td>
   <td>Assign the PHP-FPM user a new <code>uid</code> in order to syncronize file system permissions with your host computer and the Docker container. You should use a value that matches your host systems local user.<br/><sub>(Type <code>id -u</code> for your uid).</sub></td>
  </tr>
  <tr>
   <td><code>NEW_GID</code></td>
   <td>int</td>
   <td><code>1000</code></td>
   <td>Assign the PHP-FPM group a new <code>gid</code> in order to syncronize file system permissions with your host computer and the Docker container. You should use a value that matches your host systems local group.<br/><sub>(Type <code>id -g</code> for your gid).</sub></td>
  </tr>
  <tr>
   <td colspan="5"></td>
  </tr>
  <tr>
   <td rowspan="6"><strong>prod</strong><br/><br/><strong>work</strong></td>
   <td><code>TIMEZONE</code></td>
   <td>string</td>
   <td><code>UTC</code></td>
   <td>Set docker OS timezone as well as PHP timezone.<br/>(Example: <code>Europe/Berlin</code>)</td>
  </tr>
  <tr>
   <td><code>DOCKER_LOGS</code></td>
   <td>bool</td>
   <td><code>1</code></td>
   <td>By default all Docker images are configured to output their PHP-FPM access and error logs to stdout and stderr. Those which support it can change the behaviour to log into files inside the container. Their respective directories are available as volumes that can be mounted to the host computer. This feature might help developer who are more comfortable with tailing or searching through actual files instead of using docker logs.<br/><br/>Set this variable to <code>0</code> in order to enable logging to files. Log files are avilable under <code>/var/log/php/</code> which is also a docker volume that can be mounted locally.</td>
  </tr>
  <tr>
   <td><code>ENABLE_MODULES</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Comma separated list of PHP modules to enable, which are not enabled by default.<br/><strong>Example:</strong><br/><code>ENABLE_MODULES=blackfire, ioncube, psr, phalcon</code></td>
  </tr>
  <tr>
   <td><code>DISABLE_MODULES</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Comma separated list of PHP modules to disable.<br/><strong>Example:</strong><br/><code>DISABLE_MODULES=swoole,imagick</code></td>
  </tr>
  <tr>
   <td><code>ENABLE_MAIL</code></td>
   <td>bool</td>
   <td><code>0</code></td>
   <td>Start local postfix with or without email catch-all.<br/><code>0</code>: Postfix service disabled.<br/><code>1</code>: Postfix service started normally.<br/><code>2</code>: Postfix service started configured for local delivery and all mails sent (even to real domains) will be catched locally. No email will ever go out. They will all be stored in a local devilbox account.<br/>Value: <code>0</code>, <code>1</code> or <code>2</code></td>
  </tr>
  <tr>
   <td><code>FORWARD_PORTS_TO_LOCALHOST</code></td>
   <td>string</td>
   <td></td>
   <td>List of remote ports to forward to 127.0.0.1.<br/><strong>Format:</strong><br/><sub><code>&lt;local-port&gt;:&lt;remote-host&gt;:&lt;remote-port&gt;</code></sub><br/>You can separate multiple entries by comma.<br/><strong>Example:</strong><br/><sub><code>3306:mysqlhost:3306, 6379:192.0.1.1:6379</code></sub></td>
  </tr>
  <tr>
   <td colspan="5"></td>
  </tr>
  <tr>
   <td rowspan="3"><strong>work</strong></td>
   <td><code>MYSQL_BACKUP_USER</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Username for mysql backups used for bundled <a href="https://mysqldump-secure.org" >mysqldump-secure</a></td>
  </tr>
  <tr>
   <td><code>MYSQL_BACKUP_PASS</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Password for mysql backups used for bundled <a href="https://mysqldump-secure.org" >mysqldump-secure</a></td>
  </tr>
  <tr>
   <td><code>MYSQL_BACKUP_HOST</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Hostname for mysql backups used for bundled <a href="https://mysqldump-secure.org" >mysqldump-secure</a></td>
  </tr>
 </tbody>
</table>
