require "./spec_helper"

describe Marten::HTTP::Response do
  describe "::new" do
    it "allows to initialize a response by common HTTP response attributes" do
      response = Marten::HTTP::Response.new(
        content: "It works!",
        content_type: "text/plain",
        status: 201
      )
      response.content.should eq "It works!"
      response.content_type.should eq "text/plain"
      response.status.should eq 201
    end

    it "sets the response content to an empty string if it is not specified" do
      response = Marten::HTTP::Response.new
      response.content.should eq ""
    end

    it "sets the response content type to text/html if it is not specified" do
      response = Marten::HTTP::Response.new
      response.content_type.should eq "text/html"
    end

    it "sets the response status to 200 if it is not specified" do
      response = Marten::HTTP::Response.new
      response.status.should eq 200
    end

    it "sets the response headers to an empty hash" do
      response = Marten::HTTP::Response.new
      response.headers.should be_empty
    end
  end

  describe "#content" do
    it "returns the response content" do
      response = Marten::HTTP::Response.new(content: "Hello")
      response.content.should eq "Hello"
    end
  end

  describe "#content_type" do
    it "returns the response content type" do
      response = Marten::HTTP::Response.new(content_type: "text/plain")
      response.content_type.should eq "text/plain"
    end
  end

  describe "#status" do
    it "returns the response status" do
      response = Marten::HTTP::Response.new(status: 404)
      response.status.should eq 404
    end
  end

  describe "#headers" do
    it "returns the response headers" do
      response = Marten::HTTP::Response.new
      response["Allow"] = "GET, POST"
      response["Content-Length"] = "0"
      response.headers.should eq({ "Allow" => "GET, POST", "Content-Length" => "0" })
    end
  end

  describe "#[]=" do
    it "sets a specific header value" do
      response = Marten::HTTP::Response.new
      response["Allow"] = "GET, POST"
      response.headers["Allow"].should eq "GET, POST"
    end
  end
end