# Students and Courses
## Course
### Migration
```
rails g migration create_courses name:string
```
### Model
```
##
# Represents a course.
class Course < ApplicationRecord
  has_many :sections, inverse_of: :course, autosave: true, dependent: :destroy
  has_many :sessions, through: :sections
end
```
## Session
### Migration
```
rails g migration create_sessions start_date:date end_date:date name:string
```
### Model
```
##
# Represents a period during which the instituation offers courses.
class Session < ApplicationRecord
  has_many :sections, inverse_of: :session, autosave: true, dependent: :destroy
  has_many :courses, through: :sections
end
```
## Section (Course in a Session)
### Migration
```
rails g migration create_sections short_name:string session:belongs_to course:belongs_to
```
### Model
Do not put `autosave: true` on the `belongs_to` side of the association.
Join records will get saved without the ID of one side of the association
(which shouldn't even pass validation but it does),
and that association is effectively lost.
```
##
# Represents a course for a particular group of students,
# given at a particular session. There may be mulitple instances of a course
# given during a session.
class Section < ApplicationRecord
  belongs_to :session, inverse_of: :sections
  belongs_to :course, inverse_of: :sections
  has_many :enrollments, inverse_of: :section, autosave: true, dependent: :destroy
  has_many :students, through: :enrollments
end
```
## Student
### Migration
```
rails g migration create_students first_name:string last_name:string
```
### Model
```
##
# Represents a student.
class Student < ApplicationRecord
  has_many :enrollments, inverse_of: :student, autosave: true
  has_many :sections, through: :enrollments
  has_many :courses, through: :sections
end
```
## Enrollment
### Migration
```
rails g migration create_enrollments student:belongs_to section:belongs_to 'final_mark:decimal{5,2}'
```
### Model
```
##
# Represents a student enrolled in a particular offering of a course.
class Enrollment < ApplicationRecord
  belongs_to :student, inverse_of: :enrollments
  belongs_to :section, inverse_of: :enrollments
end
```

# Some Data
```
cs180 = Course.new(name: "CS180")
cs181 = Course.new(name: "CS181")
fall = Session.new(name: "Fall", start_date: "2017-09-01", end_date: "2017-12-31")
winter = Session.new(name: "Winter", start_date: "2018-01-01", end_date: "2018-04-30")
# By doing both sides of the has_many side, we get reasonable behaviour.
# However, the :through association still doesn't work.
fall.sections << (cs180a = cs180.sections.build(short_name: "A"))
fall.sections << (cs180b = cs180.sections.build(short_name: "B"))
fall.sections << (cs181a = cs180.sections.build(short_name: "A"))
fall.sections << (cs181b = cs181.sections.build(short_name: "B"))
winter.sections << (cs181a_winter = cs181.sections.build(short_name: "A"))
```
