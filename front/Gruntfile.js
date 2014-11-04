module.exports = function(grunt){

    // 项目配置
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        //　SCSS to CSS
        compass: {
            development: {
                options: {
                    basePath:'src',
                    require: 'compass/import-once/activate',
                    outputStyle: 'expanded',
                    sassDir: 'sass',
                    cssDir: 'css',
                    imagesDir: 'images',
                    environment: 'development',
                    specify: 'src/sass/<%= pkg.name %>.scss',
                    banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
                }
            },
            production: {
                options: {
                    config: 'src/config.rb',
                        basePath: 'src',
                        sassDir: 'sass',
                        cssDir: 'css',
                        imagesDir: 'images',
                        environment: 'production',
                        specify: 'src/sass/<%= pkg.name %>.scss',
                        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
                }
            }
        },
        // 合并压缩js文件
        requirejs: {
            development: {
                options: {
                    baseUrl: 'src/scripts',
                    mainConfigFile: 'src/scripts/main.js',
                    name: 'main',
                    out: 'development/javascripts/<%= pkg.name %>.js',
                    keepAmdefine: true,       //确保保留Amd定义，因为zrquan.js里包含jQ等基础类库
                    optimize: "none",
                    preserveLicenseComments: true
                }
            },
            production: {
                options: {
                    baseUrl: 'src/scripts',
                    mainConfigFile: 'src/scripts/main.js',
                    name: 'main',
                    out: 'build/javascripts/<%= pkg.name %>.min.js',
                    optimize: "uglify",
                    preserveLicenseComments: false
                }
            }
        },
        copy: {
//            scripts4build: {
//                expand: true,
//                cwd: 'src/scripts',
//                src: ['**'],
//                dest: 'src/temp_scripts'
//            },
            imagesSrcToDev: {
                expand: true,
                cwd: 'src/images/',
                src: ['**','!**/icons/**', '!**/avatars/**', '!**/big-icons/**'],
                dest: 'development/images/'
            },

            //复制所需文件到front/development目录
            toDev: {
                files: [
                    {
                        expand: true,
                        cwd: 'src/images/',
                        src: ['**','!**/icons/**', '!**/avatars/**', '!**/big-icons/**'],
                        dest: 'development/images/'
                    },
                    { src:"src/css/zrquan.css", dest:"development/stylesheets/zrquan.css"},
                    { src:"src/vendors/requirejs/require.js", dest:"development/javascripts/require.js" },
                    { src:"src/vendors/html5shiv/html5shiv.js", dest:"development/javascripts/html5shiv.js" }
                ]
            },

            //从development目录发布到rails的web目录部署
            development: {
                expand: true,
                cwd: 'development',
                //需要exclude已经在compass中做成雪碧图的文件目录,见src/sass/_bass.scss定义
                src: ['**','!**/icons/**', '!**/avatars/**', '!**/big-icons/**'],
                dest: '../app/assets/'
            }
        },
        // 压缩单个文件
        uglify: {
            development : {
                options: {
                    compress: true
                },
                src: 'src/vendors/requirejs/require.js',
                dest: 'development/javascripts/require.min.js'
            },
            html5shiv : {
                options: {
                    compress: true
                },
                src: 'src/vendors/html5shiv/html5shiv.js',
                dest: 'development/javascripts/html5shiv.min.js'
            }
        },
        //监视源文件的改动，并重新构建
        //Ubuntu 需执行下面命令，放开系统对inotify的文件数量限制
        // echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
        watch: {
            scripts: {
                files: ['src/scripts/*.js'],
                tasks: ['default'],
                options: {
                    debounceDelay: 500,
                    interrupt: true
                }
            },
            sass: {
                files: ['src/sass/*.scss'],
                tasks: ['default'],
                options: {
                    debounceDelay: 500,
                    interrupt: true
                }
            }
        },
        //项目还是以JS为主，此处主要用于转换某些特定的coffeescript
        coffee: {
            compile: {
                files: {
                    'src/coffee/turbolinks.js': 'src/coffee/turbolinks.js.coffee' // 1:1 compile
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-compass');
    grunt.loadNpmTasks('grunt-contrib-requirejs');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-coffee');

    // 默认任务(发布到开发环境)
    grunt.registerTask('default', ['compass:development', 'requirejs:development',
        'copy:toDev', 'copy:development']);

    grunt.registerTask('mycoffee', ['coffee']);
};