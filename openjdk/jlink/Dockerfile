ARG jdkver
ARG JVM_DIR=/usr/lib/jvm
ARG JDK_ROOT=${JVM_DIR}/jdk-${jdkver}

FROM alpine:3.23 AS builder

ARG jdkver
ARG MODULES
ARG JVM_DIR
ARG JDK_ROOT
ARG TMP_ROOT=/tmp/jdk-${jdkver}
ARG ARCH
ARG VM

COPY jdk${jdkver}u/build/linux-$ARCH-$VM-release/images/jdk $TMP_ROOT

RUN  apk --no-cache add binutils \
  && if [ "$VM" = "custom" ] && [ "$jdkver" -le 17 ]; then libJvmDir=server; else libJvmDir=$VM; fi \
  && ln -s $libJvmDir/libjvm.so $TMP_ROOT/lib/libjvm.so \
  && if [ "$ARCH" = "arm" ]; then GC_OPTS=""; else GC_OPTS="-J-XX:+UseShenandoahGC"; fi \
  && if [ "$ARCH" = "arm" ]; then RUNTIME_GC=""; else RUNTIME_GC="--add-options -XX:+UseShenandoahGC"; fi \
  &&    case $MODULES in                     \
            all)                                           \
                MODS=$( ls ${TMP_ROOT}/jmods/          \
                      | sed "s/.jmod//"                     \
                      | tr '\n' ', '                        \
                      | sed "s/,$//")                       \
                      && echo $MODS \
  &&            ${TMP_ROOT}/bin/jlink \
                    -J-Xms256m -J-Xmx1812m \
                    $GC_OPTS \
                    $RUNTIME_GC \
                    --add-modules ${MODS}                   \
                    --compress=zip-9                            \
                    --no-man-pages                          \
                    --strip-debug                         \
                    --strip-java-debug-attributes              \
                    --module-path ${TMP_ROOT}/jmods    \
#                    --vm=$VM                     \
                    --release-info ${TMP_ROOT}/release \
                    --dedup-legal-notices=error-if-not-same-content            \
                    --output "${JDK_ROOT}"             \
                ;;                         \
            *) \
                MODS=$MODULES                            \
  &&            ${TMP_ROOT}/bin/jlink \
                    $GC_OPTS \
                    $RUNTIME_GC \
                    --add-modules ${MODS}                 \
                    --compress=zip-9                            \
                    --no-header-files                       \
                    --no-man-pages                   \
                    --strip-debug            \
                    --strip-java-debug-attributes               \
                    --module-path ${TMP_ROOT}/jmods    \
#                   --vm=$VM                             \
                    --release-info ${TMP_ROOT}/release \
                    --dedup-legal-notices=error-if-not-same-content              \
                    --output "${JDK_ROOT}"             \
                ;;                         \
            esac                                      \
  &&    ln -s $libJvmDir/libjvm.so $JDK_ROOT/lib/libjvm.so



FROM alpine:3.23 AS base

ARG JDK_ROOT

COPY --from=builder $JDK_ROOT/ $JDK_ROOT/

ENV JAVA_HOME=${JDK_ROOT} \
    PATH=${JDK_ROOT}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

