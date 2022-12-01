# igbinary

Igbinary is a drop in replacement for the standard PHP serializer. Instead of the time and space consuming textual representation used by PHP's serialize(), igbinary stores PHP data structures in a compact binary form. Memory savings are significant when using memcached, APCu, or similar memory based storages for serialized data. The typical reduction in storage requirements are around 50%. The exact percentage depends on the data.

| Platform | Url                                                              |
|----------|------------------------------------------------------------------|
| PHP.net  | https://www.php.net/manual/en/book.igbinary.php                  |
