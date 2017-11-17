# OpenTDB

This is a binding to [OpenTDB](https://opentdb.com) for fetching random trivia.

Install the usual way with Bundler.

## Sample usage

### Using a session:
```rb
session = OpenTDB::Session.new

# Get 5 questions about animals
puts session.get(5, category: 'Animals').map(&:inspect)
```

### Output:
```rb
#<OpenTDB::Question:0x00005619859ae508 @category="Animals", @type="multiple", @difficulty="medium", @question="What does &quot;hippopotamus&quot; mean and in what langauge?", @correct_answer="River Horse (Greek)", @incorrect_answers=["River Horse (Latin)", "Fat Pig (Greek)", "Fat Pig (Latin)"]>

#<OpenTDB::Question:0x00005619859ae4e0 @category="Animals", @type="multiple", @difficulty="easy", @question="What is the fastest  land animal?", @correct_answer="Cheetah", @incorrect_answers=["Lion", "Thomson&rsquo;s Gazelle", "Pronghorn Antelope"]>

#<OpenTDB::Question:0x00005619859ae4b8 @category="Animals", @type="boolean", @difficulty="medium", @question="An octopus can fit through any hole larger than its beak.", @correct_answer="True", @incorrect_answers=["False"]>

#<OpenTDB::Question:0x00005619859ae490 @category="Animals", @type="multiple", @difficulty="medium", @question="What is the scientific name for the &quot;Polar Bear&quot;?", @correct_answer="Ursus Maritimus", @incorrect_answers=["Polar Bear", "Ursus Spelaeus", "Ursus Arctos"]>

#<OpenTDB::Question:0x00005619859ae468 @category="Animals", @type="multiple", @difficulty="easy", @question="How many legs do butterflies have?", @correct_answer="6", @incorrect_answers=["2", "4", "0"]>
```

See the source code for more documentation and API.

## This repo

I wrote this script for something I ended up not using. If you would like to make use of it and add your contributions back, that's great - open a PR.

There are some general TODOs to get started in making this more usable:
- [ ] Properly gemify
- [ ] A lot of API responses have HTML entities left in them. We can use a gem to sanitize these if we wanted.

Any questions, feel free to open an issue.
