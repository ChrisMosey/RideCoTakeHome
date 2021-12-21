require 'rails_helper'

RSpec.describe "ExchangeControllers", type: :request do
  describe "GET /" do
    before do
        @list = List.create(name: "Test Name")
    end
    it "should get all lists" do
      get "/"

      assert_response 200

      body = JSON.parse(response.body)

      assert_equal @list.name, body.first["name"]
    end
  end

  describe "POST /" do
    it "should throw an error if a list name isnt provided" do
        post "/", params: {}

        assert_response 400
    end

    it "should add a new list" do
        new_list_name = "New List"
        
        post "/", params: { list_name: new_list_name }

        assert_response 200
        body = JSON.parse(response.body)

        assert_equal new_list_name, body.first["name"]
    end

    it "should return all lists if save is successful" do
        new_list_name = "New List"

        List.create(name: "list 1")
        List.create(name: "list 2")
        
        post "/", params: { list_name: new_list_name }

        assert_response 200
        body = JSON.parse(response.body)

        assert_equal 3, body.count
        assert_equal new_list_name, body.last["name"]
    end
  end

  describe "PUT /:list_id" do
    before do
        @list = List.create(name: "Test List")
    end

    it "should throw an error if a list name isnt provided" do
        put "/#{@list.id}", params: { }

        assert_response 400
    end

    it "should throw an error if a list id isnt found" do
        put "/9999", params: { list_name: "New Name" }

        assert_response 404
    end

    it "should edit the list" do
        new_list_name = "New List"
        
        put "/#{@list.id}", params: { list_name: new_list_name }

        assert_response 200
        body = JSON.parse(response.body)

        assert_equal new_list_name, body["name"]
    end
  end

  describe "DELETE /:list_id" do
    before do
        @list = List.create(name: "Test List")
    end

    it "should throw an error if a list id isnt found" do
        delete "/9999", params: {  }

        assert_response 404
    end

    it "should delete the list" do
        delete "/#{@list.id}", params: {  }

        assert_response 200
        body = JSON.parse(response.body)

        assert_nil body.find { |list| list["id"] == @list.id }
    end
  end

  describe "GET /:list_id" do
    it "should get the list name and list items" do
        list = List.create(name: "Test List");
        list_item_1 = ListItem.create(label: "bananas", list_id: list.id)

        get "/#{list.id}"
        
        assert_response 200
        body = JSON.parse(response.body)

        assert_equal list.name, body["name"]
        assert_equal list_item_1.label, body["items"].first["label"]
    end

    it "should throw an error if list id doesnt match a list" do
        get "/999"
        
        assert_response 404
    end
  end

  describe "POST /:list_id" do
    it "should throw an error if list id doesnt match a list" do
        post "/999", params: { label: "apples" }
        
        assert_response 404
    end

    it "should add a new list item" do
        list = List.create(name: "Test List");

        post "/#{list.id}", params: { label: "apples" }
        
        assert_response 200
        body = JSON.parse(response.body)

        assert_equal "apples", body["items"].first["label"]
    end
  end

  describe "PUT /:list_id/:list_item_id" do
    before do
        @list = List.create(name: "Test List");
        @list_item = ListItem.create(label: "bananas", list_id: @list.id)
    end

    it "should throw an error if list id doesnt match a list item" do
        put "/999/#{@list_item.id}", params: { label: "apples" }
        
        assert_response 404
    end
    
    it "should throw an error if list item id doesnt match a list item" do
        put "/#{@list.id}/999", params: { label: "apples" }
        
        assert_response 404
    end

    it "should update the list item label" do
        put "/#{@list.id}/#{@list_item.id}", params: { label: "apples" }
        
        assert_response 200
        body = JSON.parse(response.body)

        assert_equal "apples", body["label"]
    end

    it "should update the list item to checked" do
        put "/#{@list.id}/#{@list_item.id}", params: { checked: true }
        
        assert_response 200
        body = JSON.parse(response.body)

        assert body["checked"]
    end

    it "should not update the list item checked variable if it is not changed" do
        @list_item.update(checked: true);
        put "/#{@list.id}/#{@list_item.id}", params: { label: "apples" }
        
        assert_response 200
        body = JSON.parse(response.body)

        assert body["checked"]
    end
  end

  describe "PUT /:list_id/:list_item_id" do
    before do
        @list = List.create(name: "Test List");
        @list_item_1 = ListItem.create(label: "bananas", list_id: @list.id)
        @list_item_2 = ListItem.create(label: "pinapple", list_id: @list.id)
    end

    it "should throw an error if list id doesnt match a list item" do
        delete "/999/#{@list_item_1.id}"
        
        assert_response 404
    end
    
    it "should throw an error if list item id doesnt match a list item" do
        delete "/#{@list.id}/999"
        
        assert_response 404
    end

    it "should delete the list item" do
        delete "/#{@list.id}/#{@list_item_1.id}"
        
        assert_response 200
        body = JSON.parse(response.body)

        assert_equal 1, body["items"].length
    end
  end
end
