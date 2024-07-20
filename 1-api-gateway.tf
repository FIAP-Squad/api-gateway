resource "aws_api_gateway_rest_api" "fiap-api" {
  name = "fiap-api"

    body = jsonencode({
        openapi = "3.0.1"
        info = {
        title   = "example"
        version = "1.0"
        }
        paths = {
        "/users" = {
            get = {
            x-amazon-apigateway-integration = {
                httpMethod           = "ANY"
                payloadFormatVersion = "1.0"
                type                 = "HTTP_PROXY"
                uri                  = "http://afd3d7f3a84d34b13815bd73c825c16a-646025546.us-east-1.elb.amazonaws.com/api/users"
            }
            }
        },
        "/products" = {
            get = {
            x-amazon-apigateway-integration = {
                httpMethod           = "ANY"
                payloadFormatVersion = "1.0"
                type                 = "HTTP_PROXY"
                uri                  = "http://a659e378191c6462e87638eaec2641d1-776889456.us-east-1.elb.amazonaws.com/api/products"
            }
            }
        },
        "/orders" = {
            get = {
            x-amazon-apigateway-integration = {
                httpMethod           = "ANY"
                payloadFormatVersion = "1.0"
                type                 = "HTTP_PROXY"
                uri                  = "http://a08982a63bc024fe489f6a54c39b2d40-894307597.us-east-1.elb.amazonaws.com/api/orders"
            }
            }
        },
        "/payment" = {
            get = {
            x-amazon-apigateway-integration = {
                httpMethod           = "ANY"
                payloadFormatVersion = "1.0"
                type                 = "HTTP_PROXY"
                uri                  = "http://a856345946ac244f7befcec43abba128-1534035786.us-east-1.elb.amazonaws.com/api/payment"
            }
            }
        }
        }
    })

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