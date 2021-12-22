# RideCoTakeHome

## About
This is a basic glocery list app using Rails on the back end and React on the front end.

## Discussion
- Use rubo cop linter.
- Change application controller to something like grocery controller
- Use a list controller and a list_items controller or something
- have multiple users with multiple lists
    - new list would also take user id
- error classes would go into their own file
- should gather data like created at data and modified at date (maybe modified by?)
- use up and down in migration


# Back End
## How to Run
 - in the backend folder, run `docker-compose up`
 - if this is a fresh install, open a second terminal and run `docker-compose run web rake db:create`
 - run tests
    - run `docker exec -it backend_web_1 bash`
    - run `bundle exec rspec`