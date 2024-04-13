# Inference Pipeline
Accept user's request for machine learning model inference. Generates a prediction. Save the prediction in a database
besides and responds to the user with the same prediction.

## Hosting
1. The model file is loaded when the Flask application is initiated.
2. The Flask application is containerized with Docker.
3. The Docker container is hosted on Amazon ECS.


## Notes on the Flask application
The Flask application is running inside a Docker container on port-5000 (as set by us).
It is important to set ```host="0.0.0.0""``` otherwise the application will not accept any traffic which comes from 
outside the container by default.

```python
if __name__ == "__main__":
    app.run(port=5000, host="0.0.0.0", debug=True)
```

This is how the network traffic is routed to the flask application. 
1. User hits the docker container running on Amazon ECS Cluster.
   1. Usually, I allow only my ```IAM User``` to be able to hit the API hosted on ECS.
   2. This will be external traffic to the Docker container.
2. The ```port=5000``` of the Docker container receives the traffic and forwards it to its local ```port=5000```
where the Flask application is running.
