require 'elasticsearch/model'

module LibrarySearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name Rails.env.test? ? "library_article_test" : "library_article"

    mappings do
      indexes :title, type: :text
      indexes :body, type: :text
    end
  end
end