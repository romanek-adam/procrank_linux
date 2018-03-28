#ifndef ANDROID_BASE_H
#define ANDROID_BASE_H

#include <stdarg.h>

#include <fstream>
#include <sstream>
#include <string>

#include <boost/algorithm/string.hpp>

namespace android {
namespace base {

std::string StringPrintf(const char* format, ...) {
  enum { BUFFER_SIZE = 1024 };
  char buffer[BUFFER_SIZE];

  va_list args;
  va_start (args, format);
  int ret = vsnprintf (buffer, BUFFER_SIZE, format, args);
  va_end (args);

  if (ret < 0) {
    fprintf(stderr, "%s: vsnprintf failed: %d\n", __PRETTY_FUNCTION__, ret);
    return std::string();
  }
  else if (ret >= BUFFER_SIZE) {
    fprintf(stderr, "%s: vsnprintf failed due to insufficient buffer capacity: %d\n", __PRETTY_FUNCTION__, ret);
    return std::string();
  }

  return std::string(buffer);
}

bool ReadFileToString(const std::string& path, std::string* content,
                      bool follow_symlinks = false) {
  if (!content) {
    fprintf(stderr, "%s: invalid argument\n", __PRETTY_FUNCTION__);
    return false;
  }

  std::ifstream t(path);
  if (!t) {
    fprintf(stderr, "%s: failed to open file: %s\n", __PRETTY_FUNCTION__, path.c_str());
    return false;
  }

  std::stringstream buffer;
  buffer << t.rdbuf();
  *content = buffer.str();
  return true;
}

std::vector<std::string> Split(const std::string& s,
                               const std::string& delimiters) {
  std::vector<std::string> ret;
  boost::split(ret, s, boost::is_any_of(delimiters));
  return ret;
}

}
}

#endif /* ANDROID_BASE_H */
