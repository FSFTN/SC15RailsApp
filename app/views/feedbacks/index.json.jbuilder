json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :id, :user_id, :timestamp, :session_id, :message, :rating
  json.url feedback_url(feedback, format: :json)
end
