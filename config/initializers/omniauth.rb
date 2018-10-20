Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "1018668356082-e7lvc7vugoeibvcn1au75f5dsef2r1bq.apps.googleusercontent.com", "rQ8Kmai1rIRbfGZjAKkMtMfK"
end