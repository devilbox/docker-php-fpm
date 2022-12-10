[Permissions](syncronize-file-permissions.md) |
Tags |
[Architectures](supported-architectures.md) |
[Versions](php-versions.md) |
[Flavours](flavours.md) |
[Extensions](php-modules.md) |
[Tools](available-tools.md) |
[Env Vars](docker-env-variables.md) |
[Volumes](docker-volumes.md) |
[Base Images](base-images.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Documentation</h2>



### Docker Tags

[![](https://img.shields.io/docker/pulls/devilbox/php-fpm.svg)](https://hub.docker.com/r/devilbox/php-fpm)

#### Tagging Idea

This repository uses Docker tags to refer to different flavours and types of the PHP-FPM Docker image. Therefore `:latest` and `:<git-branch-name>` as well as `:<git-tag-name>` must be presented differently. Refer to the following table to see how tagged Docker images are produced at Docker hub:

<table>
 <thead>
  <tr>
   <th width="190">Meant Tag</th>
   <th width="300">Actual Tag</th>
   <th>Comment</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><code>:latest</code></td>
   <td>
    <code>:X.Y-base</code><br/>
    <code>:X.Y-mods</code><br/>
    <code>:X.Y-prod</code><br/>
    <code>:X.Y-slim</code><br/>
    <code>:X.Y-work</code><br/>
   </td>
   <td>Stable<br/><sub>(rolling)</sub><br/><br/>These tags are produced by the master branch of this repository.</td>
  </tr>
  <tr>
   <td><code>:&lt;git-tag-name&gt;</code></td>
   <td>
    <code>:X.Y-base-&lt;git-tag-name&gt;</code><br/>
    <code>:X.Y-mods-&lt;git-tag-name&gt;</code><br/>
    <code>:X.Y-prod-&lt;git-tag-name&gt;</code><br/>
    <code>:X.Y-slim-&lt;git-tag-name&gt;</code><br/>
    <code>:X.Y-work-&lt;git-tag-name&gt;</code><br/>
   </td>
   <td>Stable<br/><sub>(fixed)</sub><br/><br/>Every git tag will produce and preserve these Docker tags.</td>
  </tr>
  <tr>
   <td><code>:&lt;git-branch-name&gt;</code></td>
   <td>
    <code>:X.Y-base-&lt;git-branch-name&gt;</code><br/>
    <code>:X.Y-mods-&lt;git-branch-name&gt;</code><br/>
    <code>:X.Y-prod-&lt;git-branch-name&gt;</code><br/>
    <code>:X.Y-slim-&lt;git-branch-name&gt;</code><br/>
    <code>:X.Y-work-&lt;git-branch-name&gt;</code><br/>
   </td>
   <td>Feature<br/><sub>(for testing)</sub><br/><br/>Tags produced by unmerged branches. Do not rely on them as they might come and go.</td>
  </tr>
 </tbody>
</table>


#### Available Docker Tags

The following table shows a more complete overview about the offered Docker image tags.

<table>
 <thead>
  <tr>
   <th>Flavour</th>
   <th>Master Branch</th>
   <th>Git Tag</th>
  </tr>
 </thead>
 <tbody>

  <tr>
   <td rowspan="13"><strong>base</strong></td>
   <td><code>devilbox/php-fpm:5.2-base</code></td>
   <td><code>devilbox/php-fpm:5.2-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.3-base</code></td>
   <td><code>devilbox/php-fpm:5.3-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.4-base</code></td>
   <td><code>devilbox/php-fpm:5.4-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-base</code></td>
   <td><code>devilbox/php-fpm:5.5-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-base</code></td>
   <td><code>devilbox/php-fpm:5.6-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-base</code></td>
   <td><code>devilbox/php-fpm:7.0-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-base</code></td>
   <td><code>devilbox/php-fpm:7.1-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-base</code></td>
   <td><code>devilbox/php-fpm:7.2-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-base</code></td>
   <td><code>devilbox/php-fpm:7.3-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-base</code></td>
   <td><code>devilbox/php-fpm:7.4-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.0-base</code></td>
   <td><code>devilbox/php-fpm:8.0-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.1-base</code></td>
   <td><code>devilbox/php-fpm:8.1-base-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.2-base</code></td>
   <td><code>devilbox/php-fpm:8.2-base-&lt;git-tag&gt;</code></td>
  </tr>

  <tr>
   <td rowspan="13"><strong>mods</strong></td>
   <td><code>devilbox/php-fpm:5.2-mods</code></td>
   <td><code>devilbox/php-fpm:5.2-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.3-mods</code></td>
   <td><code>devilbox/php-fpm:5.3-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.4-mods</code></td>
   <td><code>devilbox/php-fpm:5.4-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-mods</code></td>
   <td><code>devilbox/php-fpm:5.5-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-mods</code></td>
   <td><code>devilbox/php-fpm:5.6-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-mods</code></td>
   <td><code>devilbox/php-fpm:7.0-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-mods</code></td>
   <td><code>devilbox/php-fpm:7.1-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-mods</code></td>
   <td><code>devilbox/php-fpm:7.2-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-mods</code></td>
   <td><code>devilbox/php-fpm:7.3-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-mods</code></td>
   <td><code>devilbox/php-fpm:7.4-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.0-mods</code></td>
   <td><code>devilbox/php-fpm:8.0-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.1-mods</code></td>
   <td><code>devilbox/php-fpm:8.1-mods-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.2-mods</code></td>
   <td><code>devilbox/php-fpm:8.2-mods-&lt;git-tag&gt;</code></td>
  </tr>

  <tr>
   <td rowspan="13"><strong>prod</strong></td>
   <td><code>devilbox/php-fpm:5.2-prod</code></td>
   <td><code>devilbox/php-fpm:5.2-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.3-prod</code></td>
   <td><code>devilbox/php-fpm:5.3-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.4-prod</code></td>
   <td><code>devilbox/php-fpm:5.4-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-prod</code></td>
   <td><code>devilbox/php-fpm:5.5-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-prod</code></td>
   <td><code>devilbox/php-fpm:5.6-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-prod</code></td>
   <td><code>devilbox/php-fpm:7.0-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-prod</code></td>
   <td><code>devilbox/php-fpm:7.1-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-prod</code></td>
   <td><code>devilbox/php-fpm:7.2-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-prod</code></td>
   <td><code>devilbox/php-fpm:7.3-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-prod</code></td>
   <td><code>devilbox/php-fpm:7.4-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.0-prod</code></td>
   <td><code>devilbox/php-fpm:8.0-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.1-prod</code></td>
   <td><code>devilbox/php-fpm:8.1-prod-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.2-prod</code></td>
   <td><code>devilbox/php-fpm:8.2-prod-&lt;git-tag&gt;</code></td>
  </tr>

  <tr>
   <td rowspan="13"><strong>slim</strong></td>
   <td><code>devilbox/php-fpm:5.2-slim</code></td>
   <td><code>devilbox/php-fpm:5.2-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.3-slim</code></td>
   <td><code>devilbox/php-fpm:5.3-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.4-slim</code></td>
   <td><code>devilbox/php-fpm:5.4-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-slim</code></td>
   <td><code>devilbox/php-fpm:5.5-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-slim</code></td>
   <td><code>devilbox/php-fpm:5.6-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-slim</code></td>
   <td><code>devilbox/php-fpm:7.0-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-slim</code></td>
   <td><code>devilbox/php-fpm:7.1-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-slim</code></td>
   <td><code>devilbox/php-fpm:7.2-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-slim</code></td>
   <td><code>devilbox/php-fpm:7.3-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-slim</code></td>
   <td><code>devilbox/php-fpm:7.4-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.0-slim</code></td>
   <td><code>devilbox/php-fpm:8.0-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.1-slim</code></td>
   <td><code>devilbox/php-fpm:8.1-slim-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.2-slim</code></td>
   <td><code>devilbox/php-fpm:8.2-slim-&lt;git-tag&gt;</code></td>
  </tr>

  <tr>
   <td rowspan="13"><strong>work</strong></td>
   <td><code>devilbox/php-fpm:5.2-work</code></td>
   <td><code>devilbox/php-fpm:5.2-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.3-work</code></td>
   <td><code>devilbox/php-fpm:5.3-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.4-work</code></td>
   <td><code>devilbox/php-fpm:5.4-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-work</code></td>
   <td><code>devilbox/php-fpm:5.5-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-work</code></td>
   <td><code>devilbox/php-fpm:5.6-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-work</code></td>
   <td><code>devilbox/php-fpm:7.0-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-work</code></td>
   <td><code>devilbox/php-fpm:7.1-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-work</code></td>
   <td><code>devilbox/php-fpm:7.2-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-work</code></td>
   <td><code>devilbox/php-fpm:7.3-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-work</code></td>
   <td><code>devilbox/php-fpm:7.4-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.0-work</code></td>
   <td><code>devilbox/php-fpm:8.0-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.1-work</code></td>
   <td><code>devilbox/php-fpm:8.1-work-&lt;git-tag&gt;</code></td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:8.2-work</code></td>
   <td><code>devilbox/php-fpm:8.2-work-&lt;git-tag&gt;</code></td>
  </tr>

 </tbody>
</table>
