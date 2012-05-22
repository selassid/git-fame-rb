describe GitFame::Base do
  let(:subject) { GitFame::Base.new({repository: @repository}) }
  describe "#authors" do
    it "should have a list of authors" do
      should have(3).authors
    end

    describe "author" do
      let(:author) { subject.authors.last }
      it "should have a bunch of commits" do
        author.raw_commits.should eq(21)
      end

      it "should respond to name" do
        author.name.should eq("Linus Oleander")
      end

      it "should have a number of locs" do
        author.raw_loc.should eq(136)
      end

      it "should have a number of files" do
        author.raw_files.should eq(6)
      end

      it "should have some percentage" do
        author.percent.should eq("12.6 / 30.9 / 40.0")
      end
    end
    describe "format" do
      let(:author) { GitFame::Author.new({raw_commits: 12345, raw_files: 6789, raw_loc: 1234})}
      it "should format #commits" do
        author.commits.should eq("12,345")
      end

      it "should format #files" do
        author.files.should eq("6,789")
      end

      it "should format #loc" do
        author.loc.should eq("1,234")
      end
    end
  end

  describe "total" do
    it "should respond to #loc, #commits and #files" do
      subject.files.should eq(15)
      subject.commits.should eq(68)
      subject.loc.should eq(1082)
    end
  end

  describe "sort" do
    it "should be able to sort #authors by name" do
      authors = GitFame::Base.new({repository: @repository, sort: "name"}).authors
      authors.map(&:name).should eq(["7rans", "Linus Oleander", "Magnus Holm"])
    end

    it "should be able to sort #authors by commits" do
      authors = GitFame::Base.new({repository: @repository, sort: "commits"}).authors
      authors.map(&:name).should eq(["Magnus Holm", "Linus Oleander", "7rans"])
    end

    it "should be able to sort #authors by files" do
      authors = GitFame::Base.new({repository: @repository, sort: "files"}).authors
      authors.map(&:name).should eq(["7rans", "Linus Oleander", "Magnus Holm"])
    end
  end

  describe "#pretty_print" do
    it "should print" do
      lambda {
        2.times { subject.pretty_puts }
      }.should_not raise_error
    end
  end

  describe ".git_repository?" do
    it "should know if a folder is a git repository [absolute path]" do
      GitFame::Base.git_repository?(@repository).should be_true
    end

    it "should know if a folder exists or not [absolute path]" do
      GitFame::Base.git_repository?("/f67c2bcbfcfa30fccb36f72dca22a817").should be_false
    end

    it "should know if a folder is a git repository [relative path]" do
      GitFame::Base.git_repository?("spec/fixtures/gash").should be_true
    end

    it "should know if a folder exists or not [relative path]" do
      GitFame::Base.git_repository?("f67c2bcbfcfa30fccb36f72dca22a817").should be_false
    end
  end
end