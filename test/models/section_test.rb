require "test_helper"

class SectionTest < ActiveSupport::TestCase
  test "Don't touch database" do
    assert_no_difference "Course.count" do
      assert_no_difference "Session.count" do
        assert_no_difference "Section.count" do
          set_up_data
        end
      end
    end
  end

  test "Add section connections work both ways" do
    set_up_data
    assert_equal [@cs180a, @cs180b], @cs180.sections
    assert_equal [@cs180a, @cs180b, @cs181a, @cs181b], @fall.sections
    assert_equal [@cs181a_winter], @winter.sections
  end

  test "Delete section connections work both ways" do
    set_up_data
    @fall.sections.delete(@cs180.sections.delete(@cs180b))
    assert_equal [@cs180a], @cs180.sections
    assert_equal [@cs180a, @cs181a, @cs181b], @fall.sections
  end

  test "Save" do
    config.logger = Logger.new(STDOUT)
    set_up_data
    assert_difference "Session.count", 2 do
      assert_difference "Section.count", 5 do
        assert_difference "Course.count", 2 do
          @cs180.save
          @cs180.sessions.each { |s| puts s.inspect }
          Session.all.each { |s| puts s.inspect }
        end
      end
    end
  end

  private

  def set_up_data
    @cs180 = Course.new(name: "CS180")
    @cs181 = Course.new(name: "CS181")
    @fall = Session.new(name: "Fall",
                        start_date: "2017-09-01",
                        end_date: "2017-12-31")
    @winter = Session.new(name: "Winter",
                          start_date: "2018-01-01",
                          end_date: "2018-04-30")
    # By doing both sides of the has_many side, we get reasonable
    # behaviour. However, the :through association still doesn't work.
    @fall.sections << (@cs180a = @cs180.sections.build(short_name: "A"))
    @fall.sections << (@cs180b = @cs180.sections.build(short_name: "B"))
    @fall.sections << (@cs181a = @cs181.sections.build(short_name: "A"))
    @fall.sections << (@cs181b = @cs181.sections.build(short_name: "B"))
    @winter.sections << (@cs181a_winter = @cs181.sections.build(short_name: "A"))
  end
end
