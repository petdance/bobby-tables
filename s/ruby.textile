h1. Ruby

In Ruby on Rails using "ActiveRecord":http://guides.rubyonrails.org/active_record_querying.html:

<code>
Person.find :all, :conditions => ['id = ? or name = ?', id, name]
</code>

or

<code>
Person.find_by_sql ['SELECT * from persons WHERE name = ?', name]
</code>

Using "Ruby/DBI":http://ruby-dbi.rubyforge.org/: analog to "Perl":./perl.html.

h2. To do

* Add some narrative.
