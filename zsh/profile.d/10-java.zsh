notify "setup java..."
if dir_exists /usr/bin/javac; then
  JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
  export JAVA_HOME
  add_to_path_if_not_exists "${JAVA_HOME}/bin"
fi
if dir_exists /usr/bin/java; then
  JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
  export JAVA_HOME
  add_to_path_if_not_exists "$JAVA_HOME"
fi
