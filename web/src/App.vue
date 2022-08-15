<script setup>
import TabView from "primevue/tabview";
import TabPanel from "primevue/tabpanel";
import Referrers from "./components/ListReferrers.vue";
import ListLayers from "./components/ListLayers.vue";
</script>

<template>
  <div class="">
    <div class="">
      <TabView>
        <TabPanel header="Couches GC">
          <ListLayers msg="Statistiques des couches du GC" />
        </TabPanel>
        <TabPanel header="Referrers">
          <Referrers msg="Statistiques Referrer"/>
        </TabPanel>
        <TabPanel header="Header III">
          Content III
        </TabPanel>
      </TabView>

    </div>
  </div>
</template>

<style scoped>
</style>
