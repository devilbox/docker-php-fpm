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


### PHP Tools (`slim`)

The following PHP cli tools are available on the `slim` flavour:

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
  <td class="tool_slim_blackfire_5.2">🗸</td>
  <td class="tool_slim_blackfire_5.3">🗸</td>
  <td class="tool_slim_blackfire_5.4">🗸</td>
  <td class="tool_slim_blackfire_5.5">🗸</td>
  <td class="tool_slim_blackfire_5.6">🗸</td>
  <td class="tool_slim_blackfire_7.0">🗸</td>
  <td class="tool_slim_blackfire_7.1">🗸</td>
  <td class="tool_slim_blackfire_7.2">🗸</td>
  <td class="tool_slim_blackfire_7.3">🗸</td>
  <td class="tool_slim_blackfire_7.4">🗸</td>
  <td class="tool_slim_blackfire_8.0">🗸</td>
  <td class="tool_slim_blackfire_8.1">🗸</td>
  <td class="tool_slim_blackfire_8.2">🗸</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://www.mongodb.com/docs/v4.4/mongo/">MongoDB client</a></td>
  <td class="tool_slim_mongo_5.2">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_mongo_5.3">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_mongo_5.4">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_mongo_5.5">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_mongo_5.6">🗸</td>
  <td class="tool_slim_mongo_7.0">🗸</td>
  <td class="tool_slim_mongo_7.1">🗸</td>
  <td class="tool_slim_mongo_7.2">🗸</td>
  <td class="tool_slim_mongo_7.3">🗸</td>
  <td class="tool_slim_mongo_7.4">🗸</td>
  <td class="tool_slim_mongo_8.0">🗸</td>
  <td class="tool_slim_mongo_8.1">🗸</td>
  <td class="tool_slim_mongo_8.2">🗸</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://dev.mysql.com/doc/refman/8.0/en/mysql.html">MySQL client</a></td>
  <td class="tool_slim_mysql_5.2">🗸</td>
  <td class="tool_slim_mysql_5.3">🗸</td>
  <td class="tool_slim_mysql_5.4">🗸</td>
  <td class="tool_slim_mysql_5.5">🗸</td>
  <td class="tool_slim_mysql_5.6">🗸</td>
  <td class="tool_slim_mysql_7.0">🗸</td>
  <td class="tool_slim_mysql_7.1">🗸</td>
  <td class="tool_slim_mysql_7.2">🗸</td>
  <td class="tool_slim_mysql_7.3">🗸</td>
  <td class="tool_slim_mysql_7.4">🗸</td>
  <td class="tool_slim_mysql_8.0">🗸</td>
  <td class="tool_slim_mysql_8.1">🗸</td>
  <td class="tool_slim_mysql_8.2">🗸</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://www.postgresql.org/docs/current/reference-client.html">PostgreSQL client</a></td>
  <td class="tool_slim_pgsql_5.2">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_pgsql_5.3">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_pgsql_5.4">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_pgsql_5.5">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_pgsql_5.6">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_pgsql_7.0">🗸<sup>\[1\]</sup></td>
  <td class="tool_slim_pgsql_7.1">🗸</td>
  <td class="tool_slim_pgsql_7.2">🗸</td>
  <td class="tool_slim_pgsql_7.3">🗸</td>
  <td class="tool_slim_pgsql_7.4">🗸</td>
  <td class="tool_slim_pgsql_8.0">🗸</td>
  <td class="tool_slim_pgsql_8.1">🗸</td>
  <td class="tool_slim_pgsql_8.2">🗸</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://redis.io/docs/manual/cli/">Redis client</a></td>
  <td class="tool_slim_redis_5.2">🗸</td>
  <td class="tool_slim_redis_5.3">🗸</td>
  <td class="tool_slim_redis_5.4">🗸</td>
  <td class="tool_slim_redis_5.5">🗸</td>
  <td class="tool_slim_redis_5.6">🗸</td>
  <td class="tool_slim_redis_7.0">🗸</td>
  <td class="tool_slim_redis_7.1">🗸</td>
  <td class="tool_slim_redis_7.2">🗸</td>
  <td class="tool_slim_redis_7.3">🗸</td>
  <td class="tool_slim_redis_7.4">🗸</td>
  <td class="tool_slim_redis_8.0">🗸</td>
  <td class="tool_slim_redis_8.1">🗸</td>
  <td class="tool_slim_redis_8.2">🗸</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://www.sqlite.org/cli.html">SQLite client</a></td>
  <td class="tool_slim_sqlite_5.2">🗸</td>
  <td class="tool_slim_sqlite_5.3">🗸</td>
  <td class="tool_slim_sqlite_5.4">🗸</td>
  <td class="tool_slim_sqlite_5.5">🗸</td>
  <td class="tool_slim_sqlite_5.6">🗸</td>
  <td class="tool_slim_sqlite_7.0">🗸</td>
  <td class="tool_slim_sqlite_7.1">🗸</td>
  <td class="tool_slim_sqlite_7.2">🗸</td>
  <td class="tool_slim_sqlite_7.3">🗸</td>
  <td class="tool_slim_sqlite_7.4">🗸</td>
  <td class="tool_slim_sqlite_8.0">🗸</td>
  <td class="tool_slim_sqlite_8.1">🗸</td>
  <td class="tool_slim_sqlite_8.2">🗸</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://github.com/devilbox/mhsendmail/">mhsendmail</a></td>
  <td class="tool_slim_mhsendmail_5.2">🗸</td>
  <td class="tool_slim_mhsendmail_5.3">🗸</td>
  <td class="tool_slim_mhsendmail_5.4">🗸</td>
  <td class="tool_slim_mhsendmail_5.5">🗸</td>
  <td class="tool_slim_mhsendmail_5.6">🗸</td>
  <td class="tool_slim_mhsendmail_7.0">🗸</td>
  <td class="tool_slim_mhsendmail_7.1">🗸</td>
  <td class="tool_slim_mhsendmail_7.2">🗸</td>
  <td class="tool_slim_mhsendmail_7.3">🗸</td>
  <td class="tool_slim_mhsendmail_7.4">🗸</td>
  <td class="tool_slim_mhsendmail_8.0">🗸</td>
  <td class="tool_slim_mhsendmail_8.1">🗸</td>
  <td class="tool_slim_mhsendmail_8.2">🗸</td>
 </tr>
 <tr>
  <td><a target="_blank" href="https://mysqldump-secure.org/">mysqldump-secure</a></td>
  <td class="tool_slim_mysqldump_secure_5.2">🗸</td>
  <td class="tool_slim_mysqldump_secure_5.3">🗸</td>
  <td class="tool_slim_mysqldump_secure_5.4">🗸</td>
  <td class="tool_slim_mysqldump_secure_5.5">🗸</td>
  <td class="tool_slim_mysqldump_secure_5.6">🗸</td>
  <td class="tool_slim_mysqldump_secure_7.0">🗸</td>
  <td class="tool_slim_mysqldump_secure_7.1">🗸</td>
  <td class="tool_slim_mysqldump_secure_7.2">🗸</td>
  <td class="tool_slim_mysqldump_secure_7.3">🗸</td>
  <td class="tool_slim_mysqldump_secure_7.4">🗸</td>
  <td class="tool_slim_mysqldump_secure_8.0">🗸</td>
  <td class="tool_slim_mysqldump_secure_8.1">🗸</td>
  <td class="tool_slim_mysqldump_secure_8.2">🗸</td>
 </tr>
</table>

> :exclamation: **\[1\]** Not available on `arm64` Docker image.



### PHP Tools (`work`)

Additionally to all of the `slim` tools shown above, the following PHP cli tools are available on the `work` flavour:

> :information_source: Click on any tool name to find out what they are


<!-- TOOLS_WORK_START -->

| Tool                               | 5.2 | 5.3 | 5.4 | 5.5 | 5.6 | 7.0 | 7.1 | 7.2 | 7.3 | 7.4 | 8.0 | 8.1 | 8.2 |
|------------------------------------|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| [angular-cli][lnk_angular-cli]     |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [asgardcms][lnk_asgardcms]         |     |     |     |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [codeception][lnk_codeception]     |     |     |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [**composer**][lnk_**composer**]   |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [**corepack**][lnk_**corepack**]   |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [deployer][lnk_deployer]           |     |     |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [eslint][lnk_eslint]               |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [grunt-cli][lnk_grunt-cli]         |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [gulp][lnk_gulp]                   |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [jq][lnk_jq]                       |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [jsonlint][lnk_jsonlint]           |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [lumen][lnk_lumen]                 |     |     |     |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [mdl][lnk_mdl]                     |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [**node**][lnk_**node**]           |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [**npm**][lnk_**npm**]             |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [**nvm**][lnk_**nvm**]             |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [phpunit][lnk_phpunit]             |     |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [**pip**][lnk_**pip**]             |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [pwncat][lnk_pwncat]               |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [wpcli][lnk_wpcli]                 |     |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [yamllint][lnk_yamllint]           |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [**yarn**][lnk_**yarn**]           |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |
| [yq][lnk_yq]                       |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |  ✓  |

[lnk_angular-cli]: ../php_tools/angular-cli
[lnk_asgardcms]: ../php_tools/asgardcms
[lnk_codeception]: ../php_tools/codeception
[lnk_**composer**]: ../.ansible/group_vars/all/work-help.yml
[lnk_**corepack**]: ../.ansible/group_vars/all/work-help.yml
[lnk_deployer]: ../php_tools/deployer
[lnk_eslint]: ../php_tools/eslint
[lnk_grunt-cli]: ../php_tools/grunt-cli
[lnk_gulp]: ../php_tools/gulp
[lnk_jq]: ../php_tools/jq
[lnk_jsonlint]: ../php_tools/jsonlint
[lnk_lumen]: ../php_tools/lumen
[lnk_mdl]: ../php_tools/mdl
[lnk_**node**]: ../.ansible/group_vars/all/work-help.yml
[lnk_**npm**]: ../.ansible/group_vars/all/work-help.yml
[lnk_**nvm**]: ../.ansible/group_vars/all/work-help.yml
[lnk_phpunit]: ../php_tools/phpunit
[lnk_**pip**]: ../.ansible/group_vars/all/work-help.yml
[lnk_pwncat]: ../php_tools/pwncat
[lnk_wpcli]: ../php_tools/wpcli
[lnk_yamllint]: ../php_tools/yamllint
[lnk_**yarn**]: ../.ansible/group_vars/all/work-help.yml
[lnk_yq]: ../php_tools/yq

<!-- TOOLS_WORK_END -->


### PHP Tools (`work`) - deprecated

> **Disclaimer:** It is currently not clear what tools are available in which PHP image (version-dependent). This documentation was done by hand and work has currently started to automate this and keep exact tools up-to-date for each of the provided PHP version.

<table>
 <thead>
  <tr>
   <th width="200">Tool</th>
   <th>Description</th>
  </tr>
 </thead>
  <tr>
   <td><a href="https://www.ansible.com/">Ansible</a></td>
   <td>Automation tool.</td>
  </tr>
  <tr>
   <td><a href="https://asgardcms.com/install">asgardcms</a></td>
   <td>AsgardCMS cli installer.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/awesome-ci">awesome-ci</a></td>
   <td>Various linting and source code analyzing tools.</td>
  </tr>
  <tr>
   <td><a href="https://codeception.com/">codeception</a></td>
   <td>Elegant and efficient testing for PHP.</td>
  </tr>
  <tr>
   <td><a href="https://getcomposer.org">composer</a></td>
   <td>Dependency Manager for PHP.</td>
  </tr>
  <tr>
   <td><a href="https://deployer.org/">deployer</a></td>
   <td>Deployment tool for PHP.</td>
  </tr>
  <tr>
   <td><a href="https://drupalconsole.com">drupal-console</a></td>
   <td>The Drupal CLI. A tool to generate boilerplate code, interact with and debug Drupal.</td>
  </tr>
  <tr>
   <td><a href="http://www.drush.org">drush</a></td>
   <td>Drush is a computer software shell-based application used to control, manipulate, and administer Drupal websites.</td>
  </tr>
  <tr>
   <td><a href="https://eslint.org">eslint</a></td>
   <td>The pluggable linting utility for JavaScript and JSX.</td>
  </tr>
  <tr>
   <td><a href="https://git-scm.com">git</a></td>
   <td>Git is a version control system for tracking changes in source files.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/nvie/gitflow">git-flow</a></td>
   <td>Git-flow tools.</td>
  </tr>
  <tr>
   <td><a href="https://gulpjs.com/">gulp</a></td>
   <td>Gulp command line JS tool.</td>
  </tr>
  <tr>
   <td><a href="https://gruntjs.com/">grunt</a></td>
   <td>Grunt command line JS tool.</td>
  </tr>
  <tr>
   <td><a href="https://brew.sh/">Homebrew</a></td>
   <td>The Missing Package Manager for macOS (or Linux).</td>
  </tr>
  <tr>
   <td><a href="https://github.com/zaach/jsonlint">jsonlint</a></td>
   <td>Json command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://stedolan.github.io/jq/">jq</a></td>
   <td>Command-line JSON processor.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/laravel/installer">laravel installer</a></td>
   <td>A CLI tool to easily install and manage the laravel framework.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/linkcheck">linkcheck</a></td>
   <td>Search for URLs in files (optionally limited by extension) and validate their HTTP status code.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/markdownlint/markdownlint">mdl</a></td>
   <td>Markdown command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/ChrisWren/mdlint">mdlint</a></td>
   <td>Markdown command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://mysqldump-secure.org">mysqldump-secure</a></td>
   <td>Secury MySQL database backup tool with encryption.</td>
  </tr>
  <tr>
   <td><a href="https://nodejs.org">nodejs</a></td>
   <td>Node.js is an open-source, cross-platform JavaScript run-time environment for executing JavaScript code server-side.</td>
  </tr>
  <tr>
   <td><a href="https://www.npmjs.com">npm</a></td>
   <td>npm is a package manager for the JavaScript programming language.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/phalcon/phalcon-devtools">phalcon-devtools</a></td>
   <td>CLI tool to generate code helping to develop faster and easy applications that use with Phalcon framework.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/squizlabs/PHP_CodeSniffer">phpcs</a></td>
   <td>PHP_CodeSniffer tokenizes PHP, JavaScript and CSS files and detects violations of a defined set of coding standards.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/squizlabs/PHP_CodeSniffer">phpcbf</a></td>
   <td>PHP Code Beautifier and Fixer.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/FriendsOfPHP/PHP-CS-Fixer">php-cs-fixer</a></td>
   <td>A tool to automatically fix PHP Coding Standards issues.</td>
  </tr>
  <tr>
   <td><a href="https://phpmd.org">phpmd</a></td>
   <td>PHP Mess Detector.</td>
  </tr>
  <tr>
   <td><a href="https://photoncms.com/resources/installing">photon</a></td>
   <td>Photon CMS cli.</td>
  </tr>
  <tr>
   <td><a href="http://sass-lang.com/">sass</a></td>
   <td>Sass CSS compiler.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/stylelint/stylelint">stylelint</a></td>
   <td>Sass/CSS command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://www.openssh.com/">ssh</a></td>
   <td>OpenSSH command line client.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/symfony/symfony-installer">symfony installer</a></td>
   <td>This is the official installer to start new projects based on the Symfony full-stack framework.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/jonas/tig">tig</a></td>
   <td>Text-mode Interface for Git.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/webpack/webpack">webpack</a></td>
   <td>A bundler for javascript and friends.</td>
  </tr>
  <tr>
   <td><a href="https://wp-cli.org">wp-cli</a></td>
   <td>WP-CLI is the command-line interface for WordPress.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/adrienverge/yamllint">yamllint</a></td>
   <td>Yaml command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://yarnpkg.com/en">yarn</a></td>
   <td>Fast, reliable and secure dependency management.</td>
  </tr>
 <tbody>
 </tbody>
</table>
