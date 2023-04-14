#!/bin/bash

# Delete files from previous run.
process_delete_onion_domain_flag() {
  local delete_onion_domain_flag="$1"

  if [ "$delete_onion_domain_flag" == "true" ]; then
    echo "Deleting your onion domain for:$project_name"
    delete_onion_domain "$project_name"
  fi
}

process_delete_ssl_certs_flag() {
  local delete_ssl_certs_flag="$1"
  local project_name="$2"

  if [ "$delete_ssl_certs_flag" == "true" ]; then
    echo "Deleting your self-signed SSL certificates for:$project_name"
  fi
}

# Prepare Firefox version.
process_firefox_to_apt_flag() {
  local firefox_to_apt_flag="$1"

  if [ "$firefox_to_apt_flag" == "true" ]; then
    swap_snap_firefox_with_ppa_apt_firefox_installation
  fi
}

# Create onion domain(s).
process_make_onion_domain_flag() {
  local make_onion_domain_flag="$1"
  local one_domain_per_service_flag="$2"
  local services="$3"

  if [ "$make_onion_domain_flag" == "true" ]; then
    install_apt_prerequisites

    if [ "$one_domain_per_service_flag" == "true" ]; then
      nr_of_services=$(get_nr_of_services "$services")
      start=0
      for ((project_nr = start; project_nr < nr_of_services; project_nr++)); do
        local local_project_port
        local project_name
        local public_port_to_access_onion

        local_project_port="$(get_project_property_by_index "$services" "$project_nr" "local_port")"
        project_name="$(get_project_property_by_index "$services" "$project_nr" "project_name")"
        public_port_to_access_onion="$(get_project_property_by_index "$services" "$project_nr" "external_port")"

        echo "Generating your onion domain for:$project_name"
        make_onion_domain "$one_domain_per_service_flag" "$project_name" "$local_project_port" "$public_port_to_access_onion"
        prepare_starting_tor "$project_name" "$local_project_port" "$public_port_to_access_onion"
      done
    fi
  fi
}

process_get_onion_domain_flag() {
  local process_get_onion_domain="$1"
  local project_name="$2"

  if [ "$process_get_onion_domain" == "true" ]; then
    local onion_domain
    onion_domain=$(get_onion_domain "$project_name")
    echo "Your onion domain for:$project_name, is:$onion_domain"

  fi
}

process_check_http_flag() {
  local check_http_flag="$1"

  if [ "$check_http_flag" == "true" ]; then
    echo "Checking your tor domain is available over http."
  fi
}

# Create SSL certificates.
process_make_project_ssl_certs_flag() {
  local make_project_ssl_certs_flag="$1"
  local one_domain_per_service_flag="$2"
  local services="$3"
  local ssl_password="$4"

  if [ "$make_project_ssl_certs_flag" == "true" ]; then

    assert_is_non_empty_string "${ssl_password}"

    assert_is_non_empty_string "${onion_domain}"
    make_root_ssl_certs "$onion_domain" "$ssl_password"

    if [ "$one_domain_per_service_flag" == "true" ]; then
      nr_of_services=$(get_nr_of_services "$services")
      start=0
      for ((project_nr = start; project_nr < nr_of_services; project_nr++)); do
        local project_name
        local public_port_to_access_onion

        project_name="$(get_project_property_by_index "$services" "$project_nr" "project_name")"
        public_port_to_access_onion="$(get_project_property_by_index "$services" "$project_nr" "external_port")"

        local onion_domain
        onion_domain="$(get_onion_domain "$project_name")"

        make_project_ssl_certs "$onion_domain" "$project_name"
        verify_onion_address_is_reachable "$project_name" "$public_port_to_access_onion" "true"
      done
    fi
  fi
}

process_apply_certs_to_project_flag() {
  local apply_certs_to_project_flag="$1"

  if [ "$apply_certs_to_project_flag" == "true" ]; then
    echo "applying certs"
  fi
}

# Verify https access to onion domain.
process_check_https_flag() {
  local check_https_flag="$1"

  if [ "$check_https_flag" == "true" ]; then
    echo "Checking your tor domain is available over https."
  fi
}

# Add self-signed ssl certificate to (apt) Firefox.
process_add_ssl_root_cert_to_apt_firefox_flag() {
  local add_ssl_root_cert_to_apt_firefox_flag="$1"
  local project_name="$2"

  if [ "$add_ssl_root_cert_to_apt_firefox_flag" == "true" ]; then
    echo "Adding your SSL certificates to firefox."

    assert_is_non_empty_string "${project_name}"
    add_self_signed_root_cert_to_firefox "$project_name"
  fi
}
