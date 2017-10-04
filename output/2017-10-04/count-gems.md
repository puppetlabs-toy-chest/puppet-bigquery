# Count gems

```sql
-- Package,Count
SELECT package, COUNT(*) count
FROM (
  SELECT REGEXP_EXTRACT(line, r'gem [\'|"](.*)[\'|"]') package, id
  FROM (
    SELECT SPLIT(content, '\n') line, id
    FROM [puppet.gemfile_contents]
    WHERE content CONTAINS 'gem' )
    GROUP BY package, id
  )
GROUP BY 1
ORDER BY count DESC
LIMIT 50;

```

| Package                                                            | Count |
|--------------------------------------------------------------------|-------|
| None                                                               | 2875  |
| puppet                                                             | 1285  |
| puppetlabs_spec_helper                                             | 1268  |
| rake                                                               | 1215  |
| puppet-lint                                                        | 837   |
| metadata-json-lint                                                 | 726   |
| beaker-rspec                                                       | 694   |
| rspec-puppet                                                       | 676   |
| puppet-blacksmith                                                  | 518   |
| beaker                                                             | 509   |
| serverspec                                                         | 444   |
| simplecov                                                          | 420   |
| facter                                                             | 415   |
| rspec-puppet-facts                                                 | 406   |
| travis                                                             | 406   |
| travis-lint                                                        | 400   |
| guard-rake                                                         | 385   |
| puppet-lint-unquoted_string-check                                  | 366   |
| pry                                                                | 346   |
| puppet-lint-leading_zero-check                                     | 344   |
| puppet-syntax                                                      | 323   |
| beaker-puppet_install_helper                                       | 320   |
| puppet-lint-absolute_classname-check                               | 318   |
| puppet-lint-trailing_comma-check                                   | 310   |
| puppet-lint-version_comparison-check                               | 248   |
| vagrant-wrapper                                                    | 244   |
| rspec                                                              | 242   |
| json                                                               | 236   |
| puppet-lint-variable_contains_upcase                               | 222   |
| puppet-lint-classes_and_types_beginning_with_digits-check          | 191   |
| rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git | 177   |
| puppet-lint-empty_string-check                                     | 156   |
| librarian-puppet                                                   | 154   |
| puppet_facts                                                       | 151   |
| puppetlabs_spec_helper', '>= 0.1.0                                 | 150   |
| puppet-lint-undef_in_function-check                                | 147   |
| facter', '>= 1.7.0                                                 | 143   |
| puppet-lint-file_ensure-check                                      | 143   |
| coveralls                                                          | 142   |
| puppet-lint-spaceship_operator_without_tag-check                   | 135   |
| simplecov-console                                                  | 135   |
| rspec-system-puppet                                                | 132   |
| rubocop                                                            | 116   |
| rspec", '< 3.2.0                                                   | 107   |
| net-ssh                                                            | 91    |
| rspec-puppet-utils                                                 | 88    |
| webmock                                                            | 84    |
| puppet-lint', '>= 0.3.2                                            | 80    |
| yard                                                               | 76    |
| sqlite3                                                            | 72    |

![Count gems](assets/count-gems.png)