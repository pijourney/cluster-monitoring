provider "postgresql" {
  host     = var.postgresql_host
  port     = var.postgresql_port
  username = var.postgresql_user
  password = var.postgresql_password
}

resource "random_password" "grafana_password" {
  length  = 20
  special = true
}

## Create user
resource "postgresql_role" "grafana" {
  name     = "grafana_db_user"
  password = random_password.grafana_password.result
  login    = true
}


## Create a database for Grafana.
resource "postgresql_database" "grafana" {
  name  = "grafana"
  owner = postgresql_role.grafana.name
}
resource "postgresql_extension" "pg_stat_statements" {
  name     = "pg_stat_statements"
  database = postgresql_database.grafana.name

}


resource "null_resource" "create_function" {
  provisioner "remote-exec" {
    inline = [
      "psql -U postgres -d ${postgresql_database.grafana.name} <<EOF",
      "CREATE OR REPLACE FUNCTION recent_query_stats() RETURNS TABLE (query text, calls bigint, pct_total_calls numeric, total_exec_time numeric, pct_total_exec_time numeric, mean_exec_time numeric, stddev_exec_time numeric) LANGUAGE sql AS \\$$ SELECT SUBSTRING(query, 0, 80) AS query, calls, ROUND(calls * 100 / SUM(calls) OVER (), 2) AS pct_total_calls, total_exec_time, ROUND(total_exec_time::numeric * 100 / SUM(total_exec_time::numeric) OVER (), 2) AS pct_total_exec_time, mean_exec_time, stddev_exec_time FROM pg_stat_statements ORDER BY calls DESC; \\$$ SECURITY DEFINER;",
      "EOF",
    ]
    connection {
      type        = "ssh"
      user        = "pi"
      private_key = file("~/.ssh/id_rsa")
      host        = "pi-1"
    }
  }
  depends_on = [
    postgresql_extension.pg_stat_statements
  ]
}

/*
// FOR PSQL 14 and above
resource "null_resource" "create_function" {
  provisioner "remote-exec" {
    inline = [
      "psql -U postgres -d ${postgresql_database.grafana.name} <<EOF",
      "CREATE OR REPLACE FUNCTION recent_query_stats() RETURNS TABLE (query text, calls bigint, min_time double precision, max_time double precision, mean_time double precision, stddev_time double precision) LANGUAGE sql AS $$ SELECT SUBSTRING(query, 0, 80) AS query, calls, ROUND(calls * 100 / SUM(calls) OVER (), 2) AS pct_total_calls, total_time, ROUND(total_time::numeric * 100 / SUM(total_time::numeric) OVER (), 2) AS pct_total_time, mean_time, stddev_time, rows FROM pg_stat_statements ORDER BY calls DESC; $$;",
      "EOF",
    ]
    connection {
      type        = "ssh"
      user        = "pi"
      private_key = file("~/.ssh/id_rsa")
      host        = "pi-1"
    }
  }
  depends_on = [
    postgresql_extension.pg_stat_statements
  ]
}
*/

## Grant access to the function.
resource "postgresql_grant" "grafana_function_access" {
  database    = postgresql_database.grafana.name
  schema      = "public"
  role        = postgresql_role.grafana.name
  object_type = "function"
  privileges  = ["EXECUTE"]
  objects     = ["recent_query_stats"]

  depends_on = [
    null_resource.create_function,
  ]
}





