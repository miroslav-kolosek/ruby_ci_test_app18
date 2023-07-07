require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "Attributes" do
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:body).of_type(:text) }
    it { should have_db_column(:status).of_type(:string) }
  end

  describe "Associations" do
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "Methods" do
    describe "#public_count" do
      let!(:article_1) { Article.create!(title: 'Article 1', body: 'article 1111111', status: 'public') }
      let!(:article_2) { Article.create!(title: 'Article 2', body: 'article 22222222', status: 'private') }

      it do
        expect(Article.public_count).to eq 1
      end
    end

    describe "#search" do
      let!(:article_1) { Article.create!(title: 'Article 1', body: 'article 1111111', status: 'public') }
      let!(:article_2) { Article.create!(title: 'Article 2', body: 'article 22222222', status: 'private') }
      let!(:article_3) { Article.create!(title: 'Article 3', body: 'article 333333333', status: 'private') }

      context "when more result" do
        before do
          Article.__elasticsearch__.delete_index! rescue nil
          Article.__elasticsearch__.create_index!
          Article.import
          sleep 2
        end

        it do
          response = Article.search("Article")
          expect(response.results.total).to eq 3
        end
      end

      context "when one result" do
        let!(:article_4) { Article.create!(title: 'Ruby on Rails', body: 'Rails is a web application development framework written in the Ruby programming language. It is designed to make programming web applications easier by making assumptions about what every developer needs to get started. It allows you to write less code while accomplishing more than many other languages and frameworks. Experienced Rails developers also report that it makes web application development more fun.', status: 'private') }

        before do
          Article.__elasticsearch__.delete_index! rescue nil
          Article.__elasticsearch__.create_index!
          Article.import
          sleep 2
        end

        it do
          response = Article.search("Rails")
          expect(response.results.total).to eq 1
        end
      end

      context "when two result" do
        let!(:article_4) { Article.create!(title: 'Ruby on Rails', body: 'Rails is a web application development framework written in the Ruby programming language. It is designed to make programming web applications easier by making assumptions about what every developer needs to get started. It allows you to write less code while accomplishing more than many other languages and frameworks. Experienced Rails developers also report that it makes web application development more fun.', status: 'private') }
        let!(:article_5) { Article.create!(title: 'Ruby on Rails 2', body: 'Rails is a web application development framework written in the Ruby programming language. It is designed to make programming web applications easier by making assumptions about what every developer needs to get started. It allows you to write less code while accomplishing more than many other languages and frameworks. Experienced Rails developers also report that it makes web application development more fun.', status: 'private') }

        before do
          Article.__elasticsearch__.delete_index! rescue nil
          Article.__elasticsearch__.create_index!
          Article.import
          sleep 2
        end

        it do
          response = Article.search("Rails")
          expect(response.results.total).to eq 2
        end
      end
    end
  end
end