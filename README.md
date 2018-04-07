# Docker PHP-FPM images

<h2><img id="options" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Options</h2>

### Environment variables

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
   <td rowspan="4"><strong>prod</strong><br/><br/><strong>work</strong></td>
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
   <td><code>ENABLE_MAIL</code></td>
   <td>bool</td>
   <td><code>0</code></td>
   <td>Enable local email catch-all.<br/>Postfix will be configured for local delivery and all mails sent (even to real domains) will be catched locally. No email will ever go out. They will all be stored in a local devilbox account.<br/>Value: <code>0</code> or <code>1</code></td>
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

### Volumes

Have a look at the following table to see all offered volumes for each Docker image flavour.

<table>
 <thead>
  <tr>
   <th>Image</th>
   <th width="220">Volumes</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td rowspan="5"><strong>prod</strong><br/><br/><strong>work</strong></td>
   <td><code>/etc/php-custom.d</code></td>
   <td>Mount this directory into your host computer and add custom <code>\*.ini</code> files in order to alter php behaviour.</td>
  </tr>
  <tr>
   <td><code>/etc/php-fpm-custom.d</code></td>
   <td>Mount this directory into your host computer and add custom PHP-FOM <code>\*.conf</code> files in order to alter PHP-FPM behaviour.</td>
  </tr>
  <tr>
   <td><code>/etc/php-modules.d</code></td>
   <td>Mount this directory into your host computer and add custo <code>\*.so</code> files in order to add your php modules.<br/><br/><strong>Note:</strong>Your should then also provide a custom <code>\*.ini</code> file in order to actually load your custom provided module.</td>
  </tr>
  <tr>
   <td><code>/var/log/php</code></td>
   <td>When setting environment variable <code>DOCKER_LOGS</code> to <code>0</code>, log files will be available under this directory.</td>
  </tr>
  <tr>
   <td><code>/var/mail</code></td>
   <td>Emails caught be the postfix catch-all (<code>ENABLE_MAIL=1</code>) will be available in this directory.</td>
  </tr>
  <tr>
   <td colspan="3"></td>
  </tr>
  <tr>
   <td rowspan="2"><strong>work</strong></td>
   <td><code>/etc/bash-custom.d</code></td>
   <td>Mount this directory into your host computer and add custom configuration files for <code>bash</code> and other tools.</td>
  </tr>
  <tr>
   <td><code>/shared/backups</code></td>
   <td>Mount this directory into your host computer to access MySQL backups created by <a href="https://mysqldump-secure.org" >mysqldump-secure</a>.</td>
  </tr>
 </tbody>
</table>


### Ports

Have a look at the following table to see all offered exposed ports for each Docker image flavour.

<table>
 <thead>
  <tr>
   <th>Image</th>
   <th width="200">Port</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td rowspan="1"><strong>base</strong><br/><strong>mods</strong><br/><strong>prod</strong><br/><strong>work</strong></td>
   <td><code>9000</code></td>
   <td>PHP-FPM listening port</td>
  </tr>
 </tbody>
</table>




<h2><img id="modules" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Modules</h2>

<table>
 <thead>
  <tr>
   <th></th>
   <th width="45%"><code>base</code></th>
   <th width="45%"><code>mods</code>, <code>prod</code> and <code>work</code></th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <th>5.4</th>
   <td id="54-base">Core, ctype, curl, date, dom, ereg, fileinfo, filter, hash, iconv, json, libxml, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, recode, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="54-mods">amqp, apc, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, ereg, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongo, mongodb, msgpack, mysql, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>5.5</th>
   <td id="55-base">Core, ctype, curl, date, dom, ereg, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="55-mods">amqp, apc, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, ereg, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongo, mongodb, msgpack, mysql, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>5.6</th>
   <td id="56-base">Core, ctype, curl, date, dom, ereg, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="56-mods">amqp, apc, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, ereg, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongo, mongodb, msgpack, mysql, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>7.0</th>
   <td id="70-base">Core, ctype, curl, date, dom, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="70-mods">amqp, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongodb, msgpack, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>7.1</th>
   <td id="71-base">Core, ctype, curl, date, dom, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="71-mods">amqp, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongodb, msgpack, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>7.2</th>
   <td id="72-base">Core, ctype, curl, date, dom, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, sodium, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="72-mods">amqp, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongodb, msgpack, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, sodium, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
 </tbody>
</table>
