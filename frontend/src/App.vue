<template>
  <div id="app">
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link>
    </div>
    qwe
    <router-view/>
  </div>
</template>

<script>
export default {
    channels: {
      GlobalChannel: {
        connected() {
          console.log('qqqconnected')
        },
        rejected() {
        },
        received() {
        },
        disconnected() {
        }
      }
    },
    mounted() {
      this.$cable.subscribe({
        channel: 'GlobalChannel',
        room: 'public'
      });
      setTimeout(() => {
        this.$cable.perform({
          channel: 'GlobalChannel',
            action: 'notify',
            data: {
                ok: 'qweqwe'
            }
        });
      }, 2000)
    }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
