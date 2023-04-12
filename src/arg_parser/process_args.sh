#!/bin/bash

# Verify input argument validity.
process_project_name_flag() {
  local project_name_flag="$1"
  local project_name="$2"

  if [ "$project_name_flag" == "true" ]; then
    echo "Verified project name:$project_name consists of valid characters."
  fi
}

process_local_project_port_flag() {
  local local_project_port_flag="$1"
  local local_project_port="$2"

  if [ "$local_project_port_flag" == "true" ]; then
    echo "Verified the port:$public_port_to_access_onion is in valid range and unused."
  fi
}

process_public_port_to_access_onion_flag() {
  local public_port_to_access_onion_flag="$1"
  local public_port_to_access_onion="$2"

  if [ "$public_port_to_access_onion_flag" == "true" ]; then
    echo "Verified the port:$public_port_to_access_onion is in valid range and unused."
  fi
}

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
  local project_name="$2"
  local local_project_port="$3"
  local public_port_to_access_onion="$4"

  if [ "$make_onion_domain_flag" == "true" ]; then
    echo "Generating your onion domain for:$project_name"
    make_onion_domain "$project_name" "$local_project_port" "$public_port_to_access_onion"
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
process_make_ssl_certs_flag() {
  local make_ssl_certs_flag="$1"
  local project_name="$2"
  local ssl_password="$3"
  local public_port_to_access_onion="$4"

  if [ "$make_ssl_certs_flag" == "true" ]; then
    echo "Generating your self-signed SSL certificates for:$project_name"

    assert_is_non_empty_string "${project_name}"
    assert_is_non_empty_string "${ssl_password}"
    local onion_domain
    onion_domain="$(get_onion_domain "$project_name")"
    assert_is_non_empty_string "${onion_domain}"
    make_ssl_certs "$onion_domain" "$project_name" "$ssl_password"
    verify_onion_address_is_reachable "$project_name" "$public_port_to_access_onion" "true"
    wait_time_sec
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
