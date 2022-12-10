[Permissions](syncronize-file-permissions.md) |
[Tags](docker-tags.md) |
[Architectures](supported-architectures.md) |
[Versions](php-versions.md) |
[Flavours](flavours.md) |
[Extensions](php-modules.md) |
[Tools](available-tools.md) |
[Env Vars](docker-env-variables.md) |
Volumes |
[Base Images](base-images.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Documentation</h2>



### Docker Volumes

Have a look at the following table to see all offered volumes for each Docker image flavour.

<table>
 <thead>
  <tr>
   <th>Image</th>
   <th width="240">Volumes</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td rowspan="8"><strong>prod</strong><br/><br/><strong>slim</strong><br/><br/><strong>work</strong></td>
   <td><code>/etc/php-custom.d</code></td>
   <td>Mount this directory into your host computer and add custom <code>\*.ini</code> files in order to alter php behaviour.</td>
  </tr>
  <tr>
   <td><code>/etc/php-fpm-custom.d</code></td>
   <td>Mount this directory into your host computer and add custom PHP-FPM <code>\*.conf</code> files in order to alter PHP-FPM behaviour.</td>
  </tr>
  <tr>
   <td><code>/etc/php-modules.d</code></td>
   <td>Mount this directory into your host computer and add custo <code>\*.so</code> files in order to add your php modules.<br/><br/><strong>Note:</strong>Your should then also provide a custom <code>\*.ini</code> file in order to actually load your custom provided module.</td>
  </tr>
  <tr>
   <td><code>/startup.1.d</code></td>
   <td>Any executable scripts ending by <code>\*.sh</code> found in this directory will be executed during startup. This is useful to supply additional commands (such as installing custom software) when the container starts up. (will run before <code>/startup.2.d</code>)</td>
  </tr>
  <tr>
   <td><code>/startup.2.d</code></td>
   <td>Any executable scripts ending by <code>\*.sh</code> found in this directory will be executed during startup. This is useful to supply additional commands (such as installing custom software) when the container starts up. (will run after <code>/startup.1.d</code>)</td>
  </tr>
  <tr>
   <td><code>/var/log/php</code></td>
   <td>When setting environment variable <code>DOCKER_LOGS</code> to <code>0</code>, log files will be available under this directory.</td>
  </tr>
  <tr>
   <td><code>/var/mail</code></td>
   <td>Emails caught be the postfix catch-all (<code>ENABLE_MAIL=2</code>) will be available in this directory.</td>
  </tr>
  <tr>
   <td><code>/etc/supervisor/custom.d</code></td>
   <td>Mount this directory into your host computer and add your own `*.conf` supervisor start-up files.<br/><br/>**Note:** Directory and file permission will be recursively set to this of `NEW_UID` and `NEW_GID`.</td>
  </tr>
  <tr>
   <td colspan="3"></td>
  </tr>
  <tr>
   <td rowspan="3"><strong>slim</strong><br/><br/><strong>work</strong></td>
   <td><code>/etc/bashrc-devilbox.d</code></td>
   <td>Mount this directory into your host computer and add custom configuration files for <code>bash</code> and other tools.</td>
  </tr>
  <tr>
   <td><code>/shared/backups</code></td>
   <td>Mount this directory into your host computer to access MySQL backups created by <a href="https://mysqldump-secure.org" >mysqldump-secure</a>.</td>
  </tr>
  <tr>
   <td><code>/ca</code></td>
   <td>Mount this directory into your host computer to bake any *.crt file that is located in there as a trusted SSL entity.</td>
  </tr>
 </tbody>
</table>
