require "test_helper"

class DagTest < ActiveSupport::TestCase
  class Person
    include Dag

    def initialize(name)
      @name = name
      @children = []
      @parents = []
    end

    attr_reader :name
    attr_accessor :children, :parents
  end

  def setup
    @person = Person.new("Me")
    @unrelated = Person.new("Unrelated")
    @parent = Person.new("Parent")
    @person.parents << @parent
    @parent.children << @person
    @grandparent = Person.new("Grandparent")
    @parent.parents << @grandparent
    @grandparent.children << @parent
    @greatgrandparent = Person.new("Great-grandparent")
    @grandparent.parents << @greatgrandparent
    @greatgrandparent.children << @grandparent
    @child = Person.new("Child")
    @person.children << @child
    @child.parents << @person
    @grandchild = Person.new("Grandchild")
    @child.children << @grandchild
    @grandchild.parents << @child
    @greatgrandchild = Person.new("Great-grandchild")
    @grandchild.children << @greatgrandchild
    @greatgrandchild.parents << @grandchild
  end

  test "ancestors of person" do
    assert_equal [@parent, @grandparent, @greatgrandparent],
                 @person.ancestors
  end

  test "and_ancestors of person" do
    assert_equal [@person, @parent, @grandparent, @greatgrandparent],
                 @person.and_ancestors
  end

  test "descendants of person" do
    assert_equal [@child, @grandchild, @greatgrandchild],
                 @person.descendants
  end

  test "and_descendants of person" do
    assert_equal [@person, @child, @grandchild, @greatgrandchild],
                 @person.and_descendants
  end
end
