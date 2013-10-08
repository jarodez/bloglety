json.array!(@comments) do |comment|
  json.extract! comment, :id, :user_id, :article_id, :body, :done, :created_at, :updated_at
  json.url articles_url(comment, format: :json)
end
