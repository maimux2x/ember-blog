require "test_helper"

class CSVImportJobTest < ActiveJob::TestCase
  def create_csv_import(posts = nil)
    posts ||= "published_at,title,body,tag_names\n"

    import = CSVImport.create!
    import.file.attach(
      io:           StringIO.new(posts),
      filename:     "test.csv",
      content_type: "test/csv"
    )

    import
  end

  test "enqueues job" do
    import = create_csv_import

    assert_enqueued_with(job: CSVImportJob) do
      CSVImportJob.perform_later(import)
    end
  end

  test "creates posts via csv" do
    import = create_csv_import(<<~CSV)
      published_at,title,body,tag_names
      2026-01-18,Title1,Body1,"tag1,tag2"
    CSV

    assert_difference "Post.count", 1 do
      CSVImportJob.perform_now(import)
    end

    post = Post.last
    assert_equal "2026-01-18T00:00:00Z", post.published_at.iso8601
    assert_equal "Title1", post.title
    assert_equal "Body1", post.body
    assert_equal [ "tag1", "tag2" ], post.tag_names
  end

  test "creates multiple posts" do
    import = create_csv_import(<<~CSV)
      published_at,title,body,tag_names
      2026-01-15,Title1,Body1,"tag1"
      2026-01-18,Title2,Body2,"test2"
    CSV

    assert_difference "Post.count", 2 do
      CSVImportJob.perform_now(import)
    end
  end

  test "handle validation errors" do
    import = create_csv_import(<<~CSV)
      published_at,title,body,tag_names
      2026-01-18,,Body1,"tag1,tag2"
    CSV

    assert_no_difference "Post.count" do
      CSVImportJob.perform_now(import)
    end
  end

  test "continues processing after error" do
    import = create_csv_import(<<~CSV)
      published_at,title,body,tag_names
      2026-01-15,Title1,Body1,"tag1"
      2026-01-16,,Body2,"tag2"
      2026-01-18,Title3,Body3,"test3"
    CSV

    assert_difference "Post.count", 2 do
      CSVImportJob.perform_now(import)
    end
  end
end
