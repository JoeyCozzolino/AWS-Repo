# Load required libraries
require 'aws-sdk-s3'  # AWS SDK for S3 interaction
require 'pry'         # Debugging tool
require 'securerandom' # Secure UUID generation

# Get the bucket name from environment variables
bucket_name = ENV['BUCKET_NAME']
region = 'us-east-2'  # Define the AWS region

# Initialize an S3 client
client = Aws::S3::Client.new(region: region)

# Create an S3 bucket (if it doesn’t already exist)
resp = client.create_bucket({
  bucket: bucket_name, 
  create_bucket_configuration: {
    location_constraint: region
  }
})
#binding.pry

# Generate a random number of files (between 1 and 6)
number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"

# Loop through the number of files to create and upload
number_of_files.times.each do |i|
  puts "Creating file i: #{i}"
  
  filename = "file_#{i}.txt"  # Define the filename
  output_path = "/tmp/#{filename}"  # Define local storage path

  # Create and write a random UUID into the file
  File.open(output_path, "w") do |f|
    f.write SecureRandom.uuid
  end

  # Upload the file to S3
  File.open(output_path, 'rb') do |file|
    client.put_object(
      bucket: bucket_name, 
      key: filename, 
      body: file  # Upload file contents
    )
  end
end

puts "Files successfully uploaded to S3 bucket: #{bucket_name}"
