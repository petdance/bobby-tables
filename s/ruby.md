Ruby
====

In Ruby on Rails using [ActiveRecord](http://guides.rubyonrails.org/active_record_querying.html):

    Person.find :all, :conditions => ['id = ? or name = ?', id, name]

or

    Person.find_by_sql ['SELECT * from persons WHERE name = ?', name]


Using [Ruby/DBI](http://ruby-dbi.rubyforge.org/): analog to [Perl](./perl.html).

To do
-----

-   Add some narrative.
