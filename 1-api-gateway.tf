resource "aws_api_gateway_rest_api" "fiap-api" {
  name = "fiap-api"

    body = jsonencode({
        openapi = "3.0.1"
        info = {
        title   = "example"
        version = "1.0"
        }
        paths = {
        "/path1" = {
            get = {
            x-amazon-apigateway-integration = {
                httpMethod           = "GET"
                payloadFormatVersion = "1.0"
                type                 = "HTTP_PROXY"
                uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
            }
            }
        }
        }
    })

## PARA PROJETO DA FIAP
    # body = jsonencode({
    #     openapi = "3.0.1"
    #     info = {
    #     title   = "example"
    #     version = "1.0"
    #     }
    #     paths = {
    #     "/users" = {
    #         get = {
    #         x-amazon-apigateway-integration = {
    #             httpMethod           = "GET"
    #             payloadFormatVersion = "1.0"
    #             type                 = "HTTP_PROXY"
    #             uri                  = "http://endpoint-classic-load-balancer/users"
    #         }
    #         }
    #     },
    #     "/products" = {
    #         get = {
    #         x-amazon-apigateway-integration = {
    #             httpMethod           = "GET"
    #             payloadFormatVersion = "1.0"
    #             type                 = "HTTP_PROXY"
    #             uri                  = "http://endpoint-classic-load-balancer/products"
    #         }
    #         }
    #     },
    #     "/orders" = {
    #         get = {
    #         x-amazon-apigateway-integration = {
    #             httpMethod           = "GET"
    #             payloadFormatVersion = "1.0"
    #             type                 = "HTTP_PROXY"
    #             uri                  = "http://endpoint-classic-load-balancer/orders"
    #         }
    #         }
    #     }
    #     }
    # })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "fiap-api" {
  rest_api_id = aws_api_gateway_rest_api.fiap-api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.fiap-api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "fiap-api" {
  deployment_id = aws_api_gateway_deployment.fiap-api.id
  rest_api_id   = aws_api_gateway_rest_api.fiap-api.id
  stage_name    = "prod"
}