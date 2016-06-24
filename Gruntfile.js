﻿﻿var process = require('process');
var gruntDeploy = require('./gruntConfigs/grunt-deploy');
var npmInstall = require('./gruntConfigs/npm-install');
var zip = require('./gruntConfigs/grunt-zip');
var s3Upload = require('./gruntConfigs/grunt-s3Upload');
var createBootScript = require('./gruntConfigs/grunt-createBootScript');
var launchInstance = require('./gruntConfigs/grunt-launchInstance');

module.exports = function(grunt) {
    var bucketName = grunt.option('bucketName');
    var profileName = grunt.option('profileName');
    var securityGroup = grunt.option('securityGroup');

    /* Load grunt task adapters */

    grunt.event.on('coverage', function(lcovFileContents, done) {
        done();
    });

    /* Register composite grunt tasks */

    grunt.registerTask('gruntDeploy', gruntDeploy('socaldemo'));
    grunt.registerTask('npmInstall', npmInstall('socaldemo'));
    grunt.registerTask('zipDeploy', zip('socaldemo'));
    grunt.registerTask('s3Upload', s3Upload('socaldemo', bucketName, profileName));
    grunt.registerTask('createBootScript', createBootScript('socaldemo', bucketName, 'lb-web-central'));
    grunt.registerTask('launchInstance', launchInstance('socaldemo', profileName, 'demo', securityGroup));


    grunt.registerTask('deploy', ['gruntDeploy','npmInstall', 'zipDeploy', 's3Upload', 'createBootScript', 'launchInstance']);

};