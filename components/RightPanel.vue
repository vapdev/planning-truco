<template>
    <div class="justify-between h-full overflow-x-hidden backdrop-blur-sm bg-white/10 border-l border-white/20 transition-all sm:max-w-[480px] w-full sm:relative absolute top-0 right-0 z-50">
        <div class="absolute top-0 right-0 min-w-full px-6 py-5">
            <div class="flex justify-between items-center mb-6">
                <div>
                    <div class="text-2xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">Issues</div>
                    <div class="text-sm text-gray-300">{{ issues.length }} issues • {{ issuesTotalPoints }} points</div>
                </div>
                <button @click="$emit('close')"
                    class="block sm:hidden p-2 rounded-lg hover:bg-white/10 transition-colors duration-300 text-gray-300 hover:text-white">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>

            <div class="mt-6 flex flex-col gap-4 flex-grow overflow-x-hidden text-nowrap">
                <draggable class="dragArea list-group w-full" :list="issues" @change="changeDraggable">
                    <div v-for="(issue, i) in issues" :key="issue.id"
                        class="group backdrop-blur-sm bg-white/5 border border-white/10 hover:bg-white/10 rounded-xl flex flex-col justify-between py-4 px-4 mb-4 transform transition-all duration-300 hover:scale-y-105 hover:shadow-lg animate-fade-in-issue"
                        :style="{ animationDelay: `${i * 0.1}s` }">
                        <div class="flex justify-between items-center mb-2">
                            <div class="text-sm font-medium text-purple-400">#{{ i + 1 }}</div>
                            <div class="text-sm text-gray-400">Points</div>
                        </div>
                        <div class="flex justify-between items-center mb-2">
                            <div class="font-semibold text-white">{{ issue.title }}</div>
                            <div class="font-bold text-xl bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">{{ issue.points }}</div>
                        </div>
                        <div v-if="issue.link" class="mb-2">
                            <a target="_blank" :href="issue.link"
                                class="text-sm text-blue-400 hover:text-blue-300 underline transition-colors duration-300">{{
                                    issue.link }}</a>
                        </div>
                        <div v-if="issue.description" class="text-sm text-gray-300">{{ issue.description }}</div>
                    </div>
                </draggable>

                <UAccordion class="text-white backdrop-blur-sm bg-white/5 border border-white/10 rounded-xl" 
                    open-icon="i-heroicons-plus" close-icon="i-heroicons-minus"
                    :items="accordionItems">
                    <template #default="{ item, index, open }">
                        <div class="text-center p-4">
                            <p class="text-sm text-gray-400">
                                {{ $t("addNewIssue") }}
                            </p>
                        </div>
                    </template>
                    <template #item="{ item }">
                        <div class="backdrop-blur-sm bg-white/5 border border-white/10 rounded-xl flex flex-col justify-between py-4 px-4 space-y-3">
                            <UInput color="gray" variant="outline" v-model="title" 
                                class="rounded-lg"
                                :ui="{ wrapper: 'relative', base: 'bg-white/5 border-white/20 text-white placeholder-gray-400 focus:border-purple-400 focus:ring-purple-400' }"
                                :placeholder="$t('issueTitle')" />
                            <UInput color="gray" variant="outline" v-model="description" 
                                class="rounded-lg"
                                :ui="{ wrapper: 'relative', base: 'bg-white/5 border-white/20 text-white placeholder-gray-400 focus:border-purple-400 focus:ring-purple-400' }"
                                :placeholder="$t('issueDescription')" />
                            <UInput color="gray" variant="outline" v-model="link" 
                                class="rounded-lg"
                                :ui="{ wrapper: 'relative', base: 'bg-white/5 border-white/20 text-white placeholder-gray-400 focus:border-purple-400 focus:ring-purple-400' }"
                                :placeholder="$t('issueLink')" />
                            <div class="flex justify-between gap-3">
                                <button type="button" 
                                    class="flex-1 px-4 py-2 bg-white/5 border border-white/20 text-gray-300 rounded-lg hover:bg-white/10 hover:text-white transition-all duration-300">
                                    {{ $t('clean') }}
                                </button>
                                <button @click="handleAddIssue" type="button"
                                    class="flex-1 px-4 py-2 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-lg hover:from-purple-700 hover:to-pink-700 transition-all duration-300 transform hover:scale-105">
                                    {{ $t('confirm') }}
                                </button>
                            </div>
                        </div>
                    </template>
                </UAccordion>
            </div>
        </div>
    </div>
</template>
<script setup>
import { VueDraggableNext as draggable } from 'vue-draggable-next'

const { t } = useNuxtApp()
const userStore = useUserStore();
const { issues } = storeToRefs(userStore);
const title = ref("");
const description = ref("");
const link = ref("");


const issuesTotalPoints = computed(() => issues.value.reduce((acc, issue) => acc + issue.points, 0));

const handleAddIssue = () => {
    const obj = { title: title.value, description: description.value, link: link.value };
    title.value = "";
    description.value = "";
    link.value = "";
    userStore.ws.send(JSON.stringify({ type: "newIssue", roomUUID: userStore.roomUUID, issue: obj }));
};


function changeDraggable() {
    userStore.ws.send(JSON.stringify({ type: "issueOrder", roomUUID: userStore.roomUUID, issues: issues.value.map((issue) => issue.uuid) }));
}


</script>

<style scoped>
@keyframes fade-in-issue {
  from {
    opacity: 0;
    transform: translateX(20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.animate-fade-in-issue {
  animation: fade-in-issue 0.5s ease-out both;
}

.backdrop-blur-sm {
  backdrop-filter: blur(8px);
}

/* Custom input styles */
:deep(.ui-input input) {
  background: rgba(255, 255, 255, 0.05) !important;
  border-color: rgba(255, 255, 255, 0.2) !important;
  color: white !important;
}

:deep(.ui-input input:focus) {
  border-color: rgb(168 85 247) !important;
  --tw-ring-color: rgb(168 85 247) !important;
}

:deep(.ui-input input::placeholder) {
  color: rgb(156 163 175) !important;
}
</style>