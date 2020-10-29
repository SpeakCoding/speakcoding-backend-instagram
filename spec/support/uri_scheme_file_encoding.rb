
def uri_scheme_encode_image(filename)
  file = fixture_file_upload(filename, "image/png")
  "data:image/png;base64,#{Base64.encode64(file.read).gsub(/\n/,"")}"
end
