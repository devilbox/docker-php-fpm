[Permissions](syncronize-file-permissions.md) |
[Tags](docker-tags.md) |
[Architectures](supported-architectures.md) |
[Versions](php-versions.md) |
[Flavours](flavours.md) |
[Extensions](php-modules.md) |
Tools |
[Env Vars](docker-env-variables.md) |
[Volumes](docker-volumes.md) |
[Base Images](base-images.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Documentation</h2>


:information_source: For details on how to generate modules see **[Abuser Documentation: Build your own image](../doc/abuser/README.md)**<br/>


### PHP Tools ([`prod`](flavours.md#prod))

The following PHP cli tools are available on the [`prod`](flavours.md#prod) flavour:

> :information_source: Click on any tool name to find out what they are

<table>
 <tr>
   <th>Tool</th>
   <th>PHP 5.2</th>
   <th>PHP 5.3</th>
   <th>PHP 5.4</th>
   <th>PHP 5.5</th>
   <th>PHP 5.6</th>
   <th>PHP 7.0</th>
   <th>PHP 7.1</th>
   <th>PHP 7.2</th>
   <th>PHP 7.3</th>
   <th>PHP 7.4</th>
   <th>PHP 8.0</th>
   <th>PHP 8.1</th>
   <th>PHP 8.2</th>
 </tr>
 <tr>
  <td><a target="_blank" href="https://linux.die.net/man/8/cron">Cron</a></td>
  <td class="tool_prod_cron_5.2">✓</td>
  <td class="tool_prod_cron_5.3">✓</td>
  <td class="tool_prod_cron_5.4">✓</td>
  <td class="tool_prod_cron_5.5">✓</td>
  <td class="tool_prod_cron_5.6">✓</td>
  <td class="tool_prod_cron_7.0">✓</td>
  <td class="tool_prod_cron_7.1">✓</td>
  <td class="tool_prod_cron_7.2">✓</td>
  <td class="tool_prod_cron_7.3">✓</td>
  <td class="tool_prod_cron_7.4">✓</td>
  <td class="tool_prod_cron_8.0">✓</td>
  <td class="tool_prod_cron_8.1">✓</td>
  <td class="tool_prod_cron_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="http://www.postfix.org/">Postfix</a></td>
  <td class="tool_prod_postfix_5.2">✓</td>
  <td class="tool_prod_postfix_5.3">✓</td>
  <td class="tool_prod_postfix_5.4">✓</td>
  <td class="tool_prod_postfix_5.5">✓</td>
  <td class="tool_prod_postfix_5.6">✓</td>
  <td class="tool_prod_postfix_7.0">✓</td>
  <td class="tool_prod_postfix_7.1">✓</td>
  <td class="tool_prod_postfix_7.2">✓</td>
  <td class="tool_prod_postfix_7.3">✓</td>
  <td class="tool_prod_postfix_7.4">✓</td>
  <td class="tool_prod_postfix_8.0">✓</td>
  <td class="tool_prod_postfix_8.1">✓</td>
  <td class="tool_prod_postfix_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="http://www.postfix.org/pcre_table.5.html">Postfix PCRE</a></td>
  <td class="tool_prod_postfix_pcre_5.2">✓</td>
  <td class="tool_prod_postfix_pcre_5.3">✓</td>
  <td class="tool_prod_postfix_pcre_5.4">✓</td>
  <td class="tool_prod_postfix_pcre_5.5">✓</td>
  <td class="tool_prod_postfix_pcre_5.6">✓</td>
  <td class="tool_prod_postfix_pcre_7.0">✓</td>
  <td class="tool_prod_postfix_pcre_7.1">✓</td>
  <td class="tool_prod_postfix_pcre_7.2">✓</td>
  <td class="tool_prod_postfix_pcre_7.3">✓</td>
  <td class="tool_prod_postfix_pcre_7.4">✓</td>
  <td class="tool_prod_postfix_pcre_8.0">✓</td>
  <td class="tool_prod_postfix_pcre_8.1">✓</td>
  <td class="tool_prod_postfix_pcre_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://www.rsyslog.com/">Rsyslog</a></td>
  <td class="tool_prod_rsyslog_5.2">✓</td>
  <td class="tool_prod_rsyslog_5.3">✓</td>
  <td class="tool_prod_rsyslog_5.4">✓</td>
  <td class="tool_prod_rsyslog_5.5">✓</td>
  <td class="tool_prod_rsyslog_5.6">✓</td>
  <td class="tool_prod_rsyslog_7.0">✓</td>
  <td class="tool_prod_rsyslog_7.1">✓</td>
  <td class="tool_prod_rsyslog_7.2">✓</td>
  <td class="tool_prod_rsyslog_7.3">✓</td>
  <td class="tool_prod_rsyslog_7.4">✓</td>
  <td class="tool_prod_rsyslog_8.0">✓</td>
  <td class="tool_prod_rsyslog_8.1">✓</td>
  <td class="tool_prod_rsyslog_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="http://www.dest-unreach.org/socat/">Socat</a></td>
  <td class="tool_prod_socat_5.2">✓</td>
  <td class="tool_prod_socat_5.3">✓</td>
  <td class="tool_prod_socat_5.4">✓</td>
  <td class="tool_prod_socat_5.5">✓</td>
  <td class="tool_prod_socat_5.6">✓</td>
  <td class="tool_prod_socat_7.0">✓</td>
  <td class="tool_prod_socat_7.1">✓</td>
  <td class="tool_prod_socat_7.2">✓</td>
  <td class="tool_prod_socat_7.3">✓</td>
  <td class="tool_prod_socat_7.4">✓</td>
  <td class="tool_prod_socat_8.0">✓</td>
  <td class="tool_prod_socat_8.1">✓</td>
  <td class="tool_prod_socat_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="http://supervisord.org/">Supervisor</a></td>
  <td class="tool_prod_supervisor_5.2">✓</td>
  <td class="tool_prod_supervisor_5.3">✓</td>
  <td class="tool_prod_supervisor_5.4">✓</td>
  <td class="tool_prod_supervisor_5.5">✓</td>
  <td class="tool_prod_supervisor_5.6">✓</td>
  <td class="tool_prod_supervisor_7.0">✓</td>
  <td class="tool_prod_supervisor_7.1">✓</td>
  <td class="tool_prod_supervisor_7.2">✓</td>
  <td class="tool_prod_supervisor_7.3">✓</td>
  <td class="tool_prod_supervisor_7.4">✓</td>
  <td class="tool_prod_supervisor_8.0">✓</td>
  <td class="tool_prod_supervisor_8.1">✓</td>
  <td class="tool_prod_supervisor_8.2">✓</td>
 </tr>
</table>


### PHP Tools ([`slim`](flavours.md#slim))

Additionally to all of the `prod` tools shown above, the following PHP cli tools are available on the [`slim`](flavours.md#slim) flavour:

> :information_source: Click on any tool name to find out what they are

<table>
 <tr>
   <th>Tool</th>
   <th>PHP 5.2</th>
   <th>PHP 5.3</th>
   <th>PHP 5.4</th>
   <th>PHP 5.5</th>
   <th>PHP 5.6</th>
   <th>PHP 7.0</th>
   <th>PHP 7.1</th>
   <th>PHP 7.2</th>
   <th>PHP 7.3</th>
   <th>PHP 7.4</th>
   <th>PHP 8.0</th>
   <th>PHP 8.1</th>
   <th>PHP 8.2</th>
 </tr>
 <tr>
  <td><a target="_blank" href="https://blackfire.io/docs/introduction">Blackfire</a></td>
  <td class="tool_slim_blackfire_5.2">✓</td>
  <td class="tool_slim_blackfire_5.3">✓</td>
  <td class="tool_slim_blackfire_5.4">✓</td>
  <td class="tool_slim_blackfire_5.5">✓</td>
  <td class="tool_slim_blackfire_5.6">✓</td>
  <td class="tool_slim_blackfire_7.0">✓</td>
  <td class="tool_slim_blackfire_7.1">✓</td>
  <td class="tool_slim_blackfire_7.2">✓</td>
  <td class="tool_slim_blackfire_7.3">✓</td>
  <td class="tool_slim_blackfire_7.4">✓</td>
  <td class="tool_slim_blackfire_8.0">✓</td>
  <td class="tool_slim_blackfire_8.1">✓</td>
  <td class="tool_slim_blackfire_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://www.mongodb.com/docs/v4.4/mongo/">MongoDB client</a></td>
  <td class="tool_slim_mongo_5.2">✓<sup>[1]</sup></td>
  <td class="tool_slim_mongo_5.3">✓<sup>[1]</sup></td>
  <td class="tool_slim_mongo_5.4">✓<sup>[1]</sup></td>
  <td class="tool_slim_mongo_5.5">✓<sup>[1]</sup></td>
  <td class="tool_slim_mongo_5.6">✓</td>
  <td class="tool_slim_mongo_7.0">✓</td>
  <td class="tool_slim_mongo_7.1">✓</td>
  <td class="tool_slim_mongo_7.2">✓</td>
  <td class="tool_slim_mongo_7.3">✓</td>
  <td class="tool_slim_mongo_7.4">✓</td>
  <td class="tool_slim_mongo_8.0">✓</td>
  <td class="tool_slim_mongo_8.1">✓</td>
  <td class="tool_slim_mongo_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://dev.mysql.com/doc/refman/8.0/en/mysql.html">MySQL client</a></td>
  <td class="tool_slim_mysql_5.2">✓</td>
  <td class="tool_slim_mysql_5.3">✓</td>
  <td class="tool_slim_mysql_5.4">✓</td>
  <td class="tool_slim_mysql_5.5">✓</td>
  <td class="tool_slim_mysql_5.6">✓</td>
  <td class="tool_slim_mysql_7.0">✓</td>
  <td class="tool_slim_mysql_7.1">✓</td>
  <td class="tool_slim_mysql_7.2">✓</td>
  <td class="tool_slim_mysql_7.3">✓</td>
  <td class="tool_slim_mysql_7.4">✓</td>
  <td class="tool_slim_mysql_8.0">✓</td>
  <td class="tool_slim_mysql_8.1">✓</td>
  <td class="tool_slim_mysql_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://www.postgresql.org/docs/current/reference-client.html">PostgreSQL client</a></td>
  <td class="tool_slim_pgsql_5.2">✓<sup>[1]</sup></td>
  <td class="tool_slim_pgsql_5.3">✓<sup>[1]</sup></td>
  <td class="tool_slim_pgsql_5.4">✓<sup>[1]</sup></td>
  <td class="tool_slim_pgsql_5.5">✓<sup>[1]</sup></td>
  <td class="tool_slim_pgsql_5.6">✓<sup>[1]</sup></td>
  <td class="tool_slim_pgsql_7.0">✓<sup>[1]</sup></td>
  <td class="tool_slim_pgsql_7.1">✓</td>
  <td class="tool_slim_pgsql_7.2">✓</td>
  <td class="tool_slim_pgsql_7.3">✓</td>
  <td class="tool_slim_pgsql_7.4">✓</td>
  <td class="tool_slim_pgsql_8.0">✓</td>
  <td class="tool_slim_pgsql_8.1">✓</td>
  <td class="tool_slim_pgsql_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://redis.io/docs/manual/cli/">Redis client</a></td>
  <td class="tool_slim_redis_5.2">✓</td>
  <td class="tool_slim_redis_5.3">✓</td>
  <td class="tool_slim_redis_5.4">✓</td>
  <td class="tool_slim_redis_5.5">✓</td>
  <td class="tool_slim_redis_5.6">✓</td>
  <td class="tool_slim_redis_7.0">✓</td>
  <td class="tool_slim_redis_7.1">✓</td>
  <td class="tool_slim_redis_7.2">✓</td>
  <td class="tool_slim_redis_7.3">✓</td>
  <td class="tool_slim_redis_7.4">✓</td>
  <td class="tool_slim_redis_8.0">✓</td>
  <td class="tool_slim_redis_8.1">✓</td>
  <td class="tool_slim_redis_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://www.sqlite.org/cli.html">SQLite client</a></td>
  <td class="tool_slim_sqlite_5.2">✓</td>
  <td class="tool_slim_sqlite_5.3">✓</td>
  <td class="tool_slim_sqlite_5.4">✓</td>
  <td class="tool_slim_sqlite_5.5">✓</td>
  <td class="tool_slim_sqlite_5.6">✓</td>
  <td class="tool_slim_sqlite_7.0">✓</td>
  <td class="tool_slim_sqlite_7.1">✓</td>
  <td class="tool_slim_sqlite_7.2">✓</td>
  <td class="tool_slim_sqlite_7.3">✓</td>
  <td class="tool_slim_sqlite_7.4">✓</td>
  <td class="tool_slim_sqlite_8.0">✓</td>
  <td class="tool_slim_sqlite_8.1">✓</td>
  <td class="tool_slim_sqlite_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://linux.die.net/man/1/dig"><code>dig</code></a></td>
  <td class="tool_slim_dig_5.2">✓</td>
  <td class="tool_slim_dig_5.3">✓</td>
  <td class="tool_slim_dig_5.4">✓</td>
  <td class="tool_slim_dig_5.5">✓</td>
  <td class="tool_slim_dig_5.6">✓</td>
  <td class="tool_slim_dig_7.0">✓</td>
  <td class="tool_slim_dig_7.1">✓</td>
  <td class="tool_slim_dig_7.2">✓</td>
  <td class="tool_slim_dig_7.3">✓</td>
  <td class="tool_slim_dig_7.4">✓</td>
  <td class="tool_slim_dig_8.0">✓</td>
  <td class="tool_slim_dig_8.1">✓</td>
  <td class="tool_slim_dig_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://github.com/devilbox/mhsendmail/"><code>mhsendmail</code></a></td>
  <td class="tool_slim_mhsendmail_5.2">✓</td>
  <td class="tool_slim_mhsendmail_5.3">✓</td>
  <td class="tool_slim_mhsendmail_5.4">✓</td>
  <td class="tool_slim_mhsendmail_5.5">✓</td>
  <td class="tool_slim_mhsendmail_5.6">✓</td>
  <td class="tool_slim_mhsendmail_7.0">✓</td>
  <td class="tool_slim_mhsendmail_7.1">✓</td>
  <td class="tool_slim_mhsendmail_7.2">✓</td>
  <td class="tool_slim_mhsendmail_7.3">✓</td>
  <td class="tool_slim_mhsendmail_7.4">✓</td>
  <td class="tool_slim_mhsendmail_8.0">✓</td>
  <td class="tool_slim_mhsendmail_8.1">✓</td>
  <td class="tool_slim_mhsendmail_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://mysqldump-secure.org/"><code>mysqldump-secure</code></a></td>
  <td class="tool_slim_mysqldump_secure_5.2">✓</td>
  <td class="tool_slim_mysqldump_secure_5.3">✓</td>
  <td class="tool_slim_mysqldump_secure_5.4">✓</td>
  <td class="tool_slim_mysqldump_secure_5.5">✓</td>
  <td class="tool_slim_mysqldump_secure_5.6">✓</td>
  <td class="tool_slim_mysqldump_secure_7.0">✓</td>
  <td class="tool_slim_mysqldump_secure_7.1">✓</td>
  <td class="tool_slim_mysqldump_secure_7.2">✓</td>
  <td class="tool_slim_mysqldump_secure_7.3">✓</td>
  <td class="tool_slim_mysqldump_secure_7.4">✓</td>
  <td class="tool_slim_mysqldump_secure_8.0">✓</td>
  <td class="tool_slim_mysqldump_secure_8.1">✓</td>
  <td class="tool_slim_mysqldump_secure_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://linux.die.net/man/1/nc"><code>netcat</code></a></td>
  <td class="tool_slim_netcat_5.2">✓</td>
  <td class="tool_slim_netcat_5.3">✓</td>
  <td class="tool_slim_netcat_5.4">✓</td>
  <td class="tool_slim_netcat_5.5">✓</td>
  <td class="tool_slim_netcat_5.6">✓</td>
  <td class="tool_slim_netcat_7.0">✓</td>
  <td class="tool_slim_netcat_7.1">✓</td>
  <td class="tool_slim_netcat_7.2">✓</td>
  <td class="tool_slim_netcat_7.3">✓</td>
  <td class="tool_slim_netcat_7.4">✓</td>
  <td class="tool_slim_netcat_8.0">✓</td>
  <td class="tool_slim_netcat_8.1">✓</td>
  <td class="tool_slim_netcat_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://linux.die.net/man/8/ping"><code>ping</code></a></td>
  <td class="tool_slim_ping_5.2">✓</td>
  <td class="tool_slim_ping_5.3">✓</td>
  <td class="tool_slim_ping_5.4">✓</td>
  <td class="tool_slim_ping_5.5">✓</td>
  <td class="tool_slim_ping_5.6">✓</td>
  <td class="tool_slim_ping_7.0">✓</td>
  <td class="tool_slim_ping_7.1">✓</td>
  <td class="tool_slim_ping_7.2">✓</td>
  <td class="tool_slim_ping_7.3">✓</td>
  <td class="tool_slim_ping_7.4">✓</td>
  <td class="tool_slim_ping_8.0">✓</td>
  <td class="tool_slim_ping_8.1">✓</td>
  <td class="tool_slim_ping_8.2">✓</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://linux.die.net/man/8/sudo"><code>sudo</code></a></td>
  <td class="tool_slim_ping_5.2">✓</td>
  <td class="tool_slim_ping_5.3">✓</td>
  <td class="tool_slim_ping_5.4">✓</td>
  <td class="tool_slim_ping_5.5">✓</td>
  <td class="tool_slim_ping_5.6">✓</td>
  <td class="tool_slim_ping_7.0">✓</td>
  <td class="tool_slim_ping_7.1">✓</td>
  <td class="tool_slim_ping_7.2">✓</td>
  <td class="tool_slim_ping_7.3">✓</td>
  <td class="tool_slim_ping_7.4">✓</td>
  <td class="tool_slim_ping_8.0">✓</td>
  <td class="tool_slim_ping_8.1">✓</td>
  <td class="tool_slim_ping_8.2">✓</td>
 </tr>
</table>

> :exclamation: **\[1\]** Not available on `arm64` Docker image.


### PHP Tools ([`work`](flavours.md#work))

Additionally to all of the `slim` tools shown above, the following PHP cli tools are available on the [`work`](flavours.md#work) flavour:

> :information_source: Click on any tool name to find out what they are


<!-- TOOLS_WORK_START -->

| Tool                                       | PHP 5.2 | PHP 5.3 | PHP 5.4 | PHP 5.5 | PHP 5.6 | PHP 7.0 | PHP 7.1 | PHP 7.2 | PHP 7.3 | PHP 7.4 | PHP 8.0 | PHP 8.1 | PHP 8.2 |
|--------------------------------------------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
| [angular-cli][lnk_angular-cli]             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [asgardcms][lnk_asgardcms]                 |         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [awesome-ci][lnk_awesome-ci]               |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [codeception][lnk_codeception]             |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [**composer**][lnk_**composer**]           |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [**corepack**][lnk_**corepack**]           |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [deployer][lnk_deployer]                   |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [eslint][lnk_eslint]                       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [git][lnk_git]                             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [git-flow][lnk_git-flow]                   |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [grunt-cli][lnk_grunt-cli]                 |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [gulp][lnk_gulp]                           |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [jq][lnk_jq]                               |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [jsonlint][lnk_jsonlint]                   |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [laravel-installer][lnk_laravel-installer] |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [laravel-lumen][lnk_laravel-lumen]         |         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [linkcheck][lnk_linkcheck]                 |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [mdl][lnk_mdl]                             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [mdlint][lnk_mdlint]                       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [mupdf-tools][lnk_mupdf-tools]             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [**node**][lnk_**node**]                   |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [**npm**][lnk_**npm**]                     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [**nvm**][lnk_**nvm**]                     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [phalcon-devtools][lnk_phalcon-devtools]   |         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |         |
| [php-cs-fixer][lnk_php-cs-fixer]           |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |         |
| [phpcbf][lnk_phpcbf]                       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [phpcs][lnk_phpcs]                         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [phpmd][lnk_phpmd]                         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [phpunit][lnk_phpunit]                     |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [**pip**][lnk_**pip**]                     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [pm2][lnk_pm2]                             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [pwncat][lnk_pwncat]                       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [rsync][lnk_rsync]                         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [sass][lnk_sass]                           |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [shellcheck][lnk_shellcheck]               |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [ssh][lnk_ssh]                             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [stylelint][lnk_stylelint]                 |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [svn][lnk_svn]                             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [symfony-cli][lnk_symfony-cli]             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [taskfile][lnk_taskfile]                   |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [tig][lnk_tig]                             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [vim][lnk_vim]                             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [vue-cli][lnk_vue-cli]                     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [webpack-cli][lnk_webpack-cli]             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [wkhtmltopdf][lnk_wkhtmltopdf]             |         |         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [wp-cli][lnk_wp-cli]                       |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [wscat][lnk_wscat]                         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [yamllint][lnk_yamllint]                   |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [**yarn**][lnk_**yarn**]                   |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [yq][lnk_yq]                               |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
| [zsh][lnk_zsh]                             |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |

[lnk_angular-cli]: ../php_tools/angular-cli
[lnk_asgardcms]: ../php_tools/asgardcms
[lnk_awesome-ci]: ../php_tools/awesome-ci
[lnk_codeception]: ../php_tools/codeception
[lnk_**composer**]: https://getcomposer.org/
[lnk_**corepack**]: https://nodejs.org/api/corepack.html
[lnk_deployer]: ../php_tools/deployer
[lnk_eslint]: ../php_tools/eslint
[lnk_git]: ../php_tools/git
[lnk_git-flow]: ../php_tools/git-flow
[lnk_grunt-cli]: ../php_tools/grunt-cli
[lnk_gulp]: ../php_tools/gulp
[lnk_jq]: ../php_tools/jq
[lnk_jsonlint]: ../php_tools/jsonlint
[lnk_laravel-installer]: ../php_tools/laravel-installer
[lnk_laravel-lumen]: ../php_tools/laravel-lumen
[lnk_linkcheck]: ../php_tools/linkcheck
[lnk_mdl]: ../php_tools/mdl
[lnk_mdlint]: ../php_tools/mdlint
[lnk_mupdf-tools]: ../php_tools/mupdf-tools
[lnk_**node**]: https://nodejs.org/en/
[lnk_**npm**]: https://nodejs.org/en/knowledge/getting-started/npm/what-is-npm/
[lnk_**nvm**]: https://github.com/nvm-sh/nvm
[lnk_phalcon-devtools]: ../php_tools/phalcon-devtools
[lnk_php-cs-fixer]: ../php_tools/php-cs-fixer
[lnk_phpcbf]: ../php_tools/phpcbf
[lnk_phpcs]: ../php_tools/phpcs
[lnk_phpmd]: ../php_tools/phpmd
[lnk_phpunit]: ../php_tools/phpunit
[lnk_**pip**]: https://pypi.org/
[lnk_pm2]: ../php_tools/pm2
[lnk_pwncat]: ../php_tools/pwncat
[lnk_rsync]: ../php_tools/rsync
[lnk_sass]: ../php_tools/sass
[lnk_shellcheck]: ../php_tools/shellcheck
[lnk_ssh]: ../php_tools/ssh
[lnk_stylelint]: ../php_tools/stylelint
[lnk_svn]: ../php_tools/svn
[lnk_symfony-cli]: ../php_tools/symfony-cli
[lnk_taskfile]: ../php_tools/taskfile
[lnk_tig]: ../php_tools/tig
[lnk_vim]: ../php_tools/vim
[lnk_vue-cli]: ../php_tools/vue-cli
[lnk_webpack-cli]: ../php_tools/webpack-cli
[lnk_wkhtmltopdf]: ../php_tools/wkhtmltopdf
[lnk_wp-cli]: ../php_tools/wp-cli
[lnk_wscat]: ../php_tools/wscat
[lnk_yamllint]: ../php_tools/yamllint
[lnk_**yarn**]: https://yarnpkg.com/cli/install
[lnk_yq]: ../php_tools/yq
[lnk_zsh]: ../php_tools/zsh

<!-- TOOLS_WORK_END -->
