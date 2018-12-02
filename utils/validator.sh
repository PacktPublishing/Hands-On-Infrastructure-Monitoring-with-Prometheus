#!/usr/bin/env bash
set -xe

REQUIREMENTS="curl"

function check_requirements() {                                                 
  for r in ${REQUIREMENTS}; do                                                  
    if hash "${r}" > /dev/null 2>&1; then                                       
      continue                                                                  
    else                                                                        
      err "Software requirement \"${r}\" is not available"                      
      exit 1                                                                    
    fi                                                                                                                                                                                                     
  done                                                                          
} 
