# Just a Tea's API 
This Ruby on Rails app is a project aimed at exploring the following learning goals:

- A strong understanding of Rails
- Ability to create restful routes
- Demonstration of well-organized code, following OOP
- Test Driven Development
- Clear documentation

This is a Ruby on Rails backend API application with endpoints in mind for a prototype frontend ecommerce service.
The concept outline of the full app is a subscription service that allows customers to choose from monthly/yearly deliveries of packages comprised of chosen teas.

## Concept Wireframes
![image](https://user-images.githubusercontent.com/110859604/233245563-50d4e2ae-fc7b-4ece-8de6-c8d6a9d062fb.png)
![image](https://user-images.githubusercontent.com/110859604/233245617-9e4924c8-3ae7-4019-9a47-398211ae19d1.png)
## Database Schema
![image](https://user-images.githubusercontent.com/110859604/233245791-75706299-66fe-497a-a894-c5f3214b4d92.png)

## App Versions
- Ruby version 2.7.2   
- Rails 5.2.8.1

<hr>




## Getting Started

To get started with this project, follow these steps:

1. Clone the repository to your local machine:
   ```
   git clone https://github.com/Pocketzs/tea-subscription-service.git
   ```

2. Install the necessary gems:
   ```
   bundle install
   ```

3. Set up the database:
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server:
   ```
   rails server
   ```

5. Explore the API endpoints using your preferred API client. This app is not deployed and should be explored in your localhost:3000

# API Endpoints 

| Endpoint | HTTP Method | Description | 
| -------- | ----------- | ----------- |
| `/api/v1/customer_subscriptions` | POST | Sign up a customer for a subscription.  Default subscription status will be `active`.  A REQUIRED body must be passed in this request containing the keys `:customer_id` and `subscription_id` with valid ids respectively. |
| `/api/v1/customer_subscriptions/:id` | PATCH | Update the subscription `:status` of an existing `CustomerSubscription` with either `:active` or `:canceled`.  A REQUIRED body must be passed in this request containing the keys `:customer_id`, `subscription_id`, and `:status` with valid ids respectively and either `:active` or `:canceled` for status. |
| `/api/v1/customers/:customer_id/subscriptions` | GET | Get all of a customer's subscriptions both active and canceled.  Replace `:customer_id` with a valid customer id.


# Example Responses

## `POST /api/v1/customer_subscriptions`

REQUIRED Body Example (NOTE: ids MUST be valid and existing records)
```JSON
{
  "customer_id": 2,
  "subscription_id": 1
}
```

<details>
  <summary>Response Snippet</summary>

  ```JSON
  {
    "data": {
        "id": "2",
        "type": "customer_subscription",
        "attributes": {
            "customer_id": 2,
            "subscription_id": 1,
            "status": "active"
        }
    }
}
```
</details>

## `PATCH /api/v1/customer_subscriptions/1`

REQUIRED Body Example (NOTE: The only valid statuses are "canceled", "active" or 0 or 1 respectively)
```JSON
{
  "status": "canceled"
}
```

<details>
  <summary>Response Snippet</summary>

  ```JSON
  {
    "data": {
        "id": "1",
        "type": "customer_subscription",
        "attributes": {
            "customer_id": 2,
            "subscription_id": 1,
            "status": "canceled"
        }
    }
}
```
</details>
